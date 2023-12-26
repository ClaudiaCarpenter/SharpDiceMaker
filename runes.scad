face_edge = 28;
counter = 3;

// union difference intersection

module octoprismoid() {

	module flattened_octoprismoid(face_edge, height) {

		module render_hashmark(num, voffset, vchop) {
			hashes = [ "1", "2", "3" ];
			translate([ 0, 0, vchop ])
			difference() {
				translate([ 0, 0, voffset ])
				linear_extrude(1.6) intersection() {
					text(hashes[num - 1], size = face_edge / 7, valign = "center", halign = "center",
					     font = "futhark:style=Regular");
				}
				scale([ .99, .99, .75 ]) sphere(r = face_edge / 2 * .9, $fn = 300);
			}
		}

		module render_runes(start, end, angle) {
			runes = [ "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p" ];

			for (i = [start:end]) {
				rotate([ 0, 0, i * (360 / 8) ])
				{
					translate([ face_edge * .4 - 2.75, 0, 0 ]) // face_edge*.4-2.5
					rotate([ angle, 0, 90 ])
					linear_extrude(1) text(runes[i], size = face_edge / 6, valign = "center", halign = "center",
					                       font = "futhark:style=Regular");
				}
			}
		}

		difference() { // union difference intersection % *
			rotate([ 0, 0, 22.5 ])
			intersection() { //% *
				union() {
					cylinder(r1 = face_edge * .5, r2 = 0, h = height, $fn = 8);
					rotate([ 180, 0, 0 ])
					cylinder(r1 = face_edge * .5, r2 = 0, h = height, $fn = 8);
				}

				translate([ 0, 0, -height ])
				cylinder(r = face_edge / 2 * .95, h = face_edge, $fn = 8);

				scale([ .99, .99, .75 ]) sphere(r = face_edge / 2 * .9, $fn = 300);
			}

			translate([ 0, 0, -face_edge / 7 ])
                render_runes(0, 7, 133);

			translate([ 0, 0, face_edge / 7 ])
                render_runes(8, 15, 47);

			render_hashmark(counter, face_edge / 3 - .35, -.45);
			render_hashmark(counter, -face_edge / 3 - .75, .35);
		}
	}

	union() {
		flattened_octoprismoid(face_edge, face_edge / 2);
	}
}

octoprismoid();
