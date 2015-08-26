package runninghusky.com.myapplication;

import android.app.Activity;
import android.os.Bundle;
import android.widget.TextView;

public class LeadNurtureDisplayActivity extends Activity {

    private TextView mTextView;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.lead_nurture_display);
        mTextView = (TextView) findViewById(R.id.text);
    }
}
