shader_type canvas_item;

void fragment() {
    // Calculate distance from the center of the square (0.5, 0.5)
    float dist = distance(UV, vec2(0.5));
    
    // If the pixel is outside the circle radius (0.5), make it transparent
    if (dist > 0.5) {
        discard;
    }
}
