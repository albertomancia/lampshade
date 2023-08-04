void mouseDragged() {
    PVector mouse = new PVector(pmouseX, pmouseY);
    boolean handleGrabbed = true;
    
    if (mouse.dist(h1) < 30) h1 = mouse.copy();
    else if (mouse.dist(h2) < 30) h2 = mouse.copy();
    else if (mouse.dist(end) < 30) {
        end.set(mouse.x, end.y);
        h2.add(mouseX - mouse.x, 0);
        stroke(255, 150, 150);
        strokeWeight(1);
        line(0, end.y, width, end.y);
    } else {
        handleGrabbed = false;
        for (int i = 1; i < n_tiers; i ++) {
            if (mouse.dist(branchPoints[i]) < 30) {
                PVector A = branchPoints[i-1].copy();
                PVector B = intersections[i-1].copy();
                lerps[i-1] = mouse.dist(A) / (mouse.dist(A) + mouse.dist(B));
                handleGrabbed = true;
            }
        }
    }
    if (!handleGrabbed) for (int i = 0; i < n_tiers; i ++) {
        if (abs(mouse.y - tiers[i]) < 10) {
            tiers[i] = mouse.y;
        }
    }
}

void keyPressed() {
    if (key == CODED && showTemplate) {
        if (keyCode == LEFT) n_pleats --;
        else if (keyCode == RIGHT) n_pleats ++;
        n_pleats = max(n_pleats, 1);
    }

}

void keyReleased() {
    if (key == CODED) {
        if (keyCode == UP){
            if (showTemplate) aspectRatio += 0.1;
            else {
                addTier();
            }
        }
        else if (keyCode == DOWN) {
            if (showTemplate) aspectRatio -= 0.1;
            else {
                removeTier();
            }
        }
        aspectRatio = max(aspectRatio, 0.1);
        aspectRatio = round(aspectRatio*10) / (float) 10;
    }
    if (key == 'r') setTiers();
    if (key == 'l') showLines = !showLines;
    if (key == 't') showTemplate = !showTemplate;
    if (key == 's') save = true;
}
