shader_type canvas_item;

void fragment() {
    vec4 col = texture(TEXTURE, UV);
    // If pixel is near white, make it transparent
    if (col.r > 0.9 && col.g > 0.9 && col.b > 0.9) {
        col.a = 0.0;
    }
    COLOR = col;
}