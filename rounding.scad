font = "Dice\\-Face:style=Regular";

module extrude_text(some_text = "9.7", font_scale = 100, vertical_offset = 0, height = 3, multiplier = 1,
                    do_draw_text = true, offset_four = 0, extrude_multiplier = 1, round_edge = true) {
  extrude_it();

  module extrude_it() {
    radius = 0.015 * height;
    depth = round_edge ? .75 - radius : .75;
    size = round_edge ? height - radius : height;
    has_period = false;
    two_digits = false;
    is_twenty = false;
    x = 0;

    if (round_edge) {
      echo("rendering rounded text: ", some_text, size, height, depth, radius * 2);
      translate([ x, vertical_offset * multiplier, -depth + 1 - radius / 2 ])
      minkowski() {
	linear_extrude(height = depth + 1) text(text = some_text, size = size, spacing = 1 + radius,
	                                        valign = "center", halign = "center", font = font, $fn = 10);
resize([0, 0, .15]) 	
          sphere(radius*2, $fn = 10);
      }
    } else {
      echo("rendering text: ", some_text, size, height, multiplier);
      translate([ x, vertical_offset * multiplier, -depth + 1 ])
      linear_extrude(height = depth + 1, $fn = 50)
          text(text = some_text, size = size, valign = "center", halign = "center", font = font);
    }
  }
}

color("pink", .75) extrude_text();

ht = 0.015 * 3;

*color("pink", .75) resize([0, 0, .5]) sphere(ht, $fn=50);
*translate([ -.15, 0, 1 ])
extrude_text(round_edge = false);

// ext_style =
//     {BasedOnStyle : Google, UseTab : ForIndentation, ColumnLimit : 120, StatementMacros : [ rotate, translate ]};
