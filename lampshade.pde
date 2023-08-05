import processing.svg.*;
import java.util.*;
import java.text.DecimalFormat;

int n_tiers = 5, n_pleats = 40, ID = 1;
float[] tiers, lerps, angles;
double[] lengths;
float margin = 50, aspectRatio = 1.7, defaultLerp = 0.3,
      totalHeight, windowRatio;
PVector start, h1, h2, end;
PVector[] intersections, branchPoints;
DecimalFormat dfZero;

boolean showTemplate = false, showLines = true,
        savingSVG = false, paramsSaved = true;

void setup() {
    size(1300, 800);
    totalHeight = height - margin * 2;
    windowRatio = (width - 2*margin) / (height - 2*margin);

    start = new PVector(margin, margin);
    h1 = new PVector(1000, margin);
    h2 = new PVector(200, 300);
    end = new PVector(200, height - margin);
    
    resetTiers();
    resetLerps();
    smooth(4);
    dfZero = new DecimalFormat("0.0");
    
    textSize(16);
    textAlign(CENTER);
}

void draw() {
    background(255);
    loadIntersections();
    loadProfile();
    loadLengthsAndAngles();


    if (!showTemplate) {
        noFill();
        if (showLines) {
            strokeWeight(1);
            stroke(#FF0000);
            drawTiers();

            stroke(#0000FF);
            bezier(start.x, start.y, h1.x, h1.y, h2.x, h2.y, end.x, end.y);

            stroke(#009696);
            line(start.x, start.y, h1.x, h1.y);
            line(end.x, end.y, h2.x, h2.y);
        
            drawHandle(h1);
            drawHandle(h2);
            drawHandle(end);
        
            stroke(0);
            drawLerpHandles();

            fill(0);
            float scale = 100 * (tiers[n_tiers-1] - margin) / (float) Arrays.stream(lengths).sum();
            text (String.format("%.01f", scale) + "% of paper height", width - 125, tiers[n_tiers-1] / 2);
            
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
        text("pleats: " + n_pleats, 60, 20);
        text("Aspect ratio 1:" + aspectRatio, 200, 20);

        String filename = "patterns/" + String.format("%02d", ID) + "/";
        filename +=  n_pleats + "-pleats-1:" + aspectRatio + ".svg";
        if (savingSVG) beginRecord(SVG, filename);
        noFill();
        stroke(0);
        strokeWeight(1);
        drawTemplate();
        endRecord();
    }
    text("Pattern ID: " + ID, width - 125, height - 20);
    pushStyle();
    fill(#C61414);
    textSize(24);
    if(!paramsSaved) text("UNSAVED CHANGES (SHIFT-S TO SAVE)", width / 2, margin - 10);
    popStyle();
    
    savingSVG = false;
}

void resetTiers() {
    tiers = new float[n_tiers];
    for (int i = 0; i < n_tiers; i ++) {
        tiers[i] = margin + (i + 1) * totalHeight / (n_tiers + 1);
    }
}

void resetLerps() {
    lerps = new float[n_tiers-1];
    Arrays.fill(lerps, defaultLerp);
}

void addTier() {
    n_tiers ++;
    tiers = append(tiers, margin + totalHeight * n_tiers / (n_tiers + 1));
    if (n_tiers-1 > lerps.length) lerps = append(lerps, defaultLerp);
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
