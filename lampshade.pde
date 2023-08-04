import processing.svg.*;
import java.util.*;
import java.text.DecimalFormat;

int n_tiers = 5, n_pleats = 40; 
float[] tiers, lerps, angles;
double[] lengths;
float margin = 50, aspectRatio = 1.7, totalHeight, windowRatio;
PVector start, h1, h2, end;
PVector[] intersections, branchPoints;
DecimalFormat dfZero;

boolean showTemplate = false, showLines = true, save = false;

void setup() {
    size(1300, 800);
    totalHeight = height - margin * 2;
    windowRatio = (width - 2*margin) / (height - 2*margin);

    start = new PVector(margin, margin);
    h1 = new PVector(1000, margin);
    h2 = new PVector(200, 300);
    end = new PVector(200, height - margin);
    
    lerps = new float[n_tiers];
    Arrays.fill(lerps, 0.3);
    setTiers();
    smooth(4);
    dfZero = new DecimalFormat("0.0");
    
    textSize(16);

}

void draw() {
    background(255);
    loadIntersections();
    loadProfile();
    loadLengthsAndAngles();

    String s = "captures/Capture " + hour() + "-" + minute() + "-" + second() + ".svg";

    if (!showTemplate) {
        if (save) beginRecord(SVG, s);
        noFill();
        if (showLines) {
            strokeWeight(1);
            stroke(#FF0000);
            drawTiers();

            stroke(#0000FF);
            bezier(start.x, start.y, h1.x, h1.y, h2.x, h2.y, end.x, end.y);

            stroke(0, 150, 150);
            line(start.x, start.y, h1.x, h1.y);
            line(end.x, end.y, h2.x, h2.y);
        
            drawHandle(h1);
            drawHandle(h2);
            drawHandle(end);
        
            stroke(0);
            drawLerpHandles();

            fill(0);
            float scale = 100 * (tiers[n_tiers-1] - margin) / (float) Arrays.stream(lengths).sum();
            text (dfZero.format(scale) + "% of paper height", width - 200, tiers[n_tiers-1] / 2);
            strokeWeight(1);
            line(width - 125, margin, width - 125, tiers[n_tiers-1] / 2 - 14);
            line(width - 125, tiers[n_tiers-1] / 2 + 4, width - 125, tiers[n_tiers-1]);
            line(width - 130, margin, width - 120, margin);
            line(width - 130, tiers[n_tiers-1], width - 120, tiers[n_tiers-1]);
        }
        stroke(0);
        strokeWeight(3);
        drawProfile();

    } else {
        fill(0);
        text("pleats: " + n_pleats, 20, 20);
        text("Aspect ratio 1:" + aspectRatio, 100, 20);

        if (save) beginRecord(SVG, s);
        noFill();
        stroke(0);
        strokeWeight(1);
        drawTemplate();
    }
    endRecord();
    save = false;
}

void setTiers() {
    tiers = new float[n_tiers];
    for (int i = 0; i < n_tiers; i ++) {
        tiers[i] = margin + (i + 1) * totalHeight / (n_tiers + 1);
    }
}

void addTier() {
    n_tiers ++;
    tiers = append(tiers, margin + totalHeight * n_tiers / (n_tiers + 1));
    if (n_tiers > lerps.length) lerps = append(lerps, 0.7);
    for (int i = 0; i < n_tiers - 1; i ++) {
        float newTier = tiers[i] - margin;
        newTier *= (float) n_tiers / (n_tiers + 1);
        tiers[i] = newTier + margin;
    }
}

void removeTier() {
    n_tiers --;
    for (int i = 0; i < n_tiers; i ++) {
        float newTier = tiers[i] - margin;
        newTier *= (float) (n_tiers + 2) / (n_tiers + 1);
        tiers[i] = newTier + margin;
    }
    tiers = shorten(tiers);
}
