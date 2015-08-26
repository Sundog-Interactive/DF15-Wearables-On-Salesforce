package com.sundoginteractive.lead_nurture;

import android.net.Uri;
import android.os.Bundle;
import android.util.ArrayMap;
import android.util.Log;

import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.api.GoogleApiClient;
import com.google.android.gms.common.api.PendingResult;
import com.google.android.gms.common.data.FreezableUtils;
import com.google.android.gms.wearable.DataApi;
import com.google.android.gms.wearable.DataEvent;
import com.google.android.gms.wearable.DataEventBuffer;
import com.google.android.gms.wearable.DataMap;
import com.google.android.gms.wearable.DataMapItem;
import com.google.android.gms.wearable.PutDataMapRequest;
import com.google.android.gms.wearable.PutDataRequest;
import com.google.android.gms.wearable.Wearable;
import com.google.android.gms.wearable.WearableListenerService;
import com.salesforce.androidsdk.app.SalesforceSDKManager;
import com.salesforce.androidsdk.rest.RestClient;
import com.salesforce.androidsdk.rest.RestRequest;
import com.salesforce.androidsdk.rest.RestResponse;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.List;
import java.util.Map;

/**
 * Created by craigisakson on 8/26/15.
 *
 * This service keeps an eye on the datalayer and will spin up
 * when data is changed on that layer.
 */
public class DataLayerListenerService extends WearableListenerService {
    private RestClient client;
    private static String TAG = "PHONE_APP_SERVICE";
    private GoogleApiClient mGoogleApiClient;

    @Override
    public void onDataChanged(DataEventBuffer dataEvents) {
        super.onDataChanged(dataEvents);
        Log.d(TAG, "onDataChanged");

        //Get our Salesforce client (peekRestClient() is synchronous)
        this.client = SalesforceSDKManager.getInstance().getClientManager().peekRestClient();

        //Loop through the changed data and grab what we are looking for
        final List<DataEvent> events = FreezableUtils.freezeIterable(dataEvents);
        for(DataEvent event : events) {
            final Uri uri = event.getDataItem().getUri();
            final String path = uri!=null ? uri.getPath() : null;
            if("/CAMPAIGN".equals(path)) {
                final DataMap map = DataMapItem.fromDataItem(event.getDataItem()).getDataMap();
                // read your values from map:
                buildAPIClient(map.getString("campaignId"), map.getString("leadId"));
            }
        }
    }

    //Build the API client we are going to use to send data back to the watch
    //Since building the client is async, we will continue to Salesforce
    //in the onConnected method
    private void buildAPIClient(final String campaignId, final String leadId){
        mGoogleApiClient = new GoogleApiClient.Builder(this)
                .addConnectionCallbacks(new GoogleApiClient.ConnectionCallbacks() {
                    @Override
                    public void onConnected(Bundle connectionHint) {
                        Log.d(TAG, "onConnected: " + connectionHint);

                        try {
                            sendRequest(campaignId, leadId);
                        } catch (UnsupportedEncodingException e) {
                            e.printStackTrace();
                        }
                    }
                    @Override
                    public void onConnectionSuspended(int cause) {
                        Log.d(TAG, "onConnectionSuspended: " + cause);
                    }
                })
                .addOnConnectionFailedListener(new GoogleApiClient.OnConnectionFailedListener() {
                    @Override
                    public void onConnectionFailed(ConnectionResult result) {
                        Log.d(TAG, "onConnectionFailed: " + result);
                    }
                })
                // Request access only to the Wearable API
                .addApi(Wearable.API)
                .build();
        mGoogleApiClient.connect();
    }

    //Use this method to make the callout to Salesforce to insert our record.
    private void sendRequest(String campaignId, String leadId) throws UnsupportedEncodingException {
        try {
            Map<String, Object> fieldMap = new ArrayMap<String, Object>();
            fieldMap.put("LeadId", leadId);
            fieldMap.put("CampaignId", campaignId);
            RestRequest restRequest = RestRequest.getRequestForCreate(getString(R.string.api_version), "CampaignMember", fieldMap);

            client.sendAsync(restRequest, new RestClient.AsyncRequestCallback() {
                @Override
                public void onSuccess(RestRequest request, RestResponse result) {
                    try {
                        Log.d(TAG, "result:  " + result);
                        //Check the results and send them to the watch
                        boolean success = (result.asJSONObject().getBoolean("success"));
                        letWatchKnowWhatHappened(success);
                    } catch (Exception e) {
                        onError(e);
                    }
                }

                @Override
                public void onError(Exception exception) {
                    Log.d(TAG, "Exception:  " + exception.getMessage());
                }
            });
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    //This method will update the datalayer again to send
    //the results of the callout back to the watch
    private void letWatchKnowWhatHappened(boolean success){
        Log.d(TAG, "letWatchKnowWhatHappened:  " + String.valueOf(success));
        if(mGoogleApiClient==null) {
            return;
        }

        PutDataMapRequest putDataMapReq = PutDataMapRequest.create("/CAMPAIGN");
        putDataMapReq.getDataMap().putBoolean("success", success);
        putDataMapReq.getDataMap().putString("leadId", "");
        putDataMapReq.getDataMap().putString("campaignId", "");
        PutDataRequest putDataReq = putDataMapReq.asPutDataRequest();
        PendingResult<DataApi.DataItemResult> pendingResult =
                Wearable.DataApi.putDataItem(mGoogleApiClient, putDataReq);
    }
}