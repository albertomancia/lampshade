float findIntersection(float y) {
    float y0 = start.y, y1 = h1.y, y2 = h2.y, y3 = end.y;
    float a = 3*y1 + y3 - y0 - 3*y2;
    float b = 3*y0 + 3*y2 - 6*y1;
    float c = 3*y1 - 3*y0;
    float d = y0;

    // float t = solveCubic(a, b, c, d - y);
    float t = newton(a, b, c, d - y);
    return getXValue(t);
    // return t;
}

float newton(float a, float b, float c, float d) {
    float t = 0.5;
    for (int i = 0; i < 3; i ++) {
        float f = a*pow(t,3) + b*sq(t) + c*t +d;
        float df = 3*a*sq(t) + 2*b*t + c;
        t -= f / df;
    }
    return t;
}

float getXValue(float t) {
    float x0 = start.x, x1 = h1.x, x2 = h2.x, x3 = end.x;
    float a = 3*x1 + x3 - x0 - 3*x2;
    float b = 3*x0 + 3*x2 - 6*x1;
    float c = 3*x1 - 3*x0;
    float d = x0;
    return a*pow(t,3) + b*sq(t) + c*t +d;
}
