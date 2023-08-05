void saveParams() {
    JSONArray json = new JSONArray();

    PVector[] points = {start, h1, h2, end};
    String[]  names  = {"start", "h1", "h2", "end"};
    JSONObject controlPoints = packArray(points, names);
    json.setJSONObject(0, controlPoints);
    
    JSONObject constants = new JSONObject();
    constants.setInt("n_tiers", n_tiers);
    json.setJSONObject(1, constants);
    
    JSONObject Tiers = packArray(tiers, "tier");
    json.setJSONObject(2, Tiers);
    
    JSONObject Lerps = packArray(lerps, "lerp");
    json.setJSONObject(3, Lerps);
    
    String filename = "patterns/" + String.format("%02d", ID) + "/params.json";
    saveJSONArray(json, filename);
}

JSONObject packArray(float[] arr, String s) {
    JSONObject list = new JSONObject();
    for(int i = 0; i < arr.length; i ++) {
        list.setFloat(s + str(i), arr[i]);
    }        
    return list;
}

JSONObject packArray(PVector[] arr, String[] S) {
    JSONObject list = new JSONObject();
    for(int i = 0; i < arr.length; i ++) {
        list.setFloat(S[i] + 'X', arr[i].x);
        list.setFloat(S[i] + 'Y', arr[i].y);
    }
    return list;
}

void loadParams() {
    String filename = "patterns/" + String.format("%02d", ID) + "/params.json";
    JSONArray json = loadJSONArray(filename);
    if (json == null) {
        resetTiers();
        resetLerps();
        return;
    }

    JSONObject pts = json.getJSONObject(0);
    start.set(pts.getFloat("startX"), pts.getFloat("startY"));
    h1.set   (pts.getFloat("h1X"),    pts.getFloat("h1Y"));
    h2.set   (pts.getFloat("h2X"),    pts.getFloat("h2Y"));
    end.set  (pts.getFloat("endX"),   pts.getFloat("endY"));

    JSONObject constants = json.getJSONObject(1);
    n_tiers = constants.getInt("n_tiers");

    JSONObject Tiers = json.getJSONObject(2);
    tiers = unpackArray(Tiers, "tier", n_tiers);

    JSONObject Lerps = json.getJSONObject(3);
    lerps = unpackArray(Lerps, "lerp", n_tiers-1);
}

float[] unpackArray(JSONObject j, String s, int size) {
    float[] arr = new float[size];
    for(int i = 0; i < size; i ++) {
        arr[i] = j.getFloat(s + str(i));
    }
    return arr;
}
