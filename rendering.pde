void drawTiers() {
    for (float tier : tiers) {
        line(0, tier, width, tier);
    }
}

void loadIntersections() {
    intersections = new PVector[n_tiers];
    for(int i = 0; i < n_tiers; i ++) {
        intersections[i] = new PVector(findIntersection(tiers[i]), tiers[i]);
    }
}

void loadProfile() {
    branchPoints = new PVector[n_tiers];
    PVector branchPoint = start.copy();
    for(int i = 0; i < n_tiers; i ++) {
        branchPoints[i] = branchPoint.copy();
        PVector endPt = intersections[i];
        branchPoint.lerp(endPt, lerps[i]);
    }
}

void loadLengthsAndAngles() {
    lengths = new double[n_tiers*2 - 1];
    angles = new float[n_tiers - 1];
    for (int i = 0; i < n_tiers; i ++) {
        PVector A = branchPoints[i].copy();
        PVector B = intersections[i].copy();
        lengths[i*2] = A.dist(B);
        if (i < n_tiers-1) {
            PVector A2 = branchPoints[i+1].copy();
            PVector B2 = intersections[i+1].copy();
            lengths[i*2+1] = A2.dist(B);
            PVector L1 = A.sub(B);
            PVector L2 = A2.sub(B2);
            angles[i] = PVector.angleBetween(L1, L2);
        }
    }
}

void drawProfile() {
    for (int i = 0; i < n_tiers; i ++) {
        PVector A = branchPoints[i].copy();
        PVector B = intersections[i].copy();
        line(A.x, A.y, B.x, B.y);
    }
}

void drawLerpHandles() {
    for (int i = 1; i < n_tiers; i ++) {
        drawHandle(branchPoints[i]);
    }
}

void drawMeasurements() {
    fill(0);
    for (int i = 1; i < n_tiers; i ++) {
        PVector A = branchPoints[i].copy();
        float theta = degrees(angles[i-1]);
        text(theta, A.x, A.y);
    }
    // for (int i = 0; i < n_tiers; i ++) {
    //     PVector A = branchPoints[i].copy();
    //     PVector B = intersections[i].copy();
    //     PVector T = A.lerp(B, 0.5);
    //     float l = (float) lengths[i*2];
    //     text(l, T.x, T.y);
    //     if (i < n_tiers-1) {
    //         PVector A2 = branchPoints[i+1].copy();
    //         T = A2.lerp(B, 0.5);
    //         l = (float) lengths[i*2+1];
    //         text(l, T.x, T.y);
    //     }
    // }
    noFill();
}

void drawTemplate() {
    float tWidth, tHeight;
    if (aspectRatio > windowRatio) {
        tWidth = width - 2*margin;
        tHeight = tWidth / aspectRatio;
    } else {
        tHeight = height - 2*margin;
        tWidth = tHeight * aspectRatio;
    }
    float pleatWidth = tWidth / n_pleats;
    stroke(#FF0000);
    rect(margin, margin, tWidth, tHeight);
    stroke(#0000FF);
    for (float x = margin; x < tWidth + margin - 2; x += pleatWidth) {
        if (x > margin) line(x, margin, x, margin + tHeight);
        line(x + pleatWidth / 2, margin, x + pleatWidth / 2, margin + tHeight);
    }

    double sum = Arrays.stream(lengths).sum();
    float y = margin;
    for (int i = 0; i < n_tiers - 1; i ++) {
        y += tHeight * (float) lengths[i*2] / sum;
        line(margin, y, tWidth + margin, y);

        y += tHeight * (float) lengths[i*2+1] / sum;
        float theta = angles[i] / 2;
        float yOffset = tan(theta) * pleatWidth / 2;
        beginShape();
        for (float x = margin; x < tWidth + margin - 2; x += pleatWidth) {
            vertex(x, y + yOffset);
            vertex(x + pleatWidth / 2, y);
        }
        vertex(tWidth + margin, y + yOffset);
        endShape();
    }
}

void drawHandle(float x, float y) {
    circle(x, y, 5);
    circle(x, y, 30);
}

void drawHandle(PVector p) {
    drawHandle(p.x, p.y);
}
