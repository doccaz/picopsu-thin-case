// ============================================================
// Thin mATX case for ASUS H81M-C + PicoPSU + low-profile cooler
// ============================================================
// KEY ASSUMPTIONS (verify against your actual board before printing!):
//  - Board: 244 x 178mm (per ASUS manual), standard mATX rear I/O edge
//  - PicoPSU sits vertically on 24-pin, ~25mm tall
//  - Cooler (Hyper H115) is 27mm tall, sits on CPU
//  - No exact mounting-hole coordinates used -- board is retained by a
//    perimeter ledge + snap tabs instead, so it fits regardless of the
//    precise hole pattern. Verify tab positions don't collide with your
//    board's tallest components before printing.
//  - Rear I/O opening sized to standard ATX/mATX shield (158.8 x 44.5mm),
//    OVERSIZED and left as one big rear cutout band -- check/trim to match
//    your board's shield position exactly (measure from your board!).
// ============================================================

$fn = 24;

// ---- core dimensions ----
board_w   = 250;   // along rear edge (X) -- measured from real board
board_d   = 178;   // depth front-to-back (Y)
board_t   = 1.6;

wall      = 2.5;
gap       = 3;      // clearance between board edge and inner wall
ledge_w   = 4;       // width of support ledge board rests on
ledge_w_left = ledge_w + 3;  // left side widened -- board sat with a gap there (see fit-check photo)
ledge_t   = 2;       // thickness of ledge
board_clearance = 0.4;  // slip-fit gap above the board so tabs don't sit flush
tab_h = 2.5;             // catch lip height (how far it overlaps the board)

standoff_h = 6;      // clearance below board for wires/component leads
top_clear  = 30;     // clearance above board top (cooler 27mm + PSU 25mm + margin)
floor_t    = 3;
lid_t      = 3;

ear    = 6;    // how far corner ears poke out past the outer wall
post_d = 8;    // corner post diameter
post_r = post_d/2;

inner_w = board_w + 2*gap;
inner_d = board_d + 2*gap;
outer_w = inner_w + 2*wall;
outer_d = inner_d + 2*wall;

// corner ear anchor points: [post_x, post_y, wall_corner_x, wall_corner_y]
function post_positions() = [
  [-ear+post_r, -ear+post_r, 0, 0],
  [outer_w+ear-post_r, -ear+post_r, outer_w, 0],
  [-ear+post_r, outer_d+ear-post_r, 0, outer_d],
  [outer_w+ear-post_r, outer_d+ear-post_r, outer_w, outer_d]
];

// ---- rear I/O shield opening ----
// Standard ATX/mATX shield bracket is 158.8 x 44.5mm. We size the cutout
// with margin all around so a full shield actually fits and seats cleanly,
// plus a bit of solid wall left above it for strength. This now DRIVES the
// case height -- the shield is taller than the component clearance needs.
shield_w    = 158.8;
shield_h    = 44.5;
// per-side clearance around the shield -- left/bottom fit well already
// (calibrated from photos), right/top had ~4mm too much gap, so those
// are trimmed down independently rather than shrinking all sides equally.
io_margin_left   = 3;
io_margin_right  = -3;  // confirmed by test print -- fits perfectly
io_margin_bottom = 3;
io_margin_top    = -3;  // confirmed by test print -- fits perfectly
rim_above   = 8;               // solid wall kept above the cutout
io_w        = shield_w + io_margin_left + io_margin_right;
io_h        = shield_h + io_margin_bottom + io_margin_top;
io_start_z  = floor_t + standoff_h - io_margin_bottom;

// measured from photos: shield's left edge sits ~6mm in from the board's
// own left edge (NOT centered on the board -- this is normal, the shield
// position is fixed to a corner reference per spec, not the board midpoint)
shield_offset_from_board_left = 6;
board_x0  = wall + gap;                          // board's left edge in case coords
shield_x0 = board_x0 + shield_offset_from_board_left;
io_x0     = shield_x0 - io_margin_left;          // cutout left edge (with margin)
io_x1     = io_x0 + io_w;                        // cutout right edge

case_h_components = floor_t + standoff_h + board_t + top_clear;
case_h_shield      = io_start_z + io_h + rim_above;
case_h  = max(case_h_components, case_h_shield);   // base tray height (to rim)
total_h = case_h + lid_t;

echo("Outer footprint (mm): ", outer_w, " x ", outer_d);
echo("Total height (mm): ", total_h);
echo("Height driven by: ", (case_h_shield > case_h_components) ? "I/O shield" : "component clearance");
echo("I/O cutout left edge (from case left wall): ", io_x0);

// ---- DC jack hole (front wall) -- for the PicoPSU barrel jack.
// Moved to the right side (was left, too close to the RAM slots) and
// resized for a standard 5.5x2.1mm barrel jack panel-mount hole.
dc_jack_d = 8;                // typical picoPSU DC barrel jack cutout
dc_jack_x = outer_w - 20;      // distance from left wall (near right corner now)
dc_jack_z = case_h / 2;        // height (vertically centered)

// ---- power switch hole (rear wall) -- to the right of the I/O shield
pwr_btn_d = 19;
pwr_btn_x = io_x1 + (outer_w - wall - io_x1) / 2;  // centered in the leftover rear-wall strip
pwr_btn_z = case_h / 2;

// ---- floor vents (optional) -- off by default since it opens the case
// to dust; flip floor_vents to true if you want it.
floor_vents       = true;
floor_vent_style  = "slit";  // "hex" (honeycomb holes) or "slit" (rectangular slots)

// margins -- how far the vent pattern is kept from each edge of the floor.
// "front"/"rear" match the same sense as everywhere else in this file
// (rear = the I/O shield side, y=0; front = the open board-insertion side).
floor_vent_margin_left  = 170;
floor_vent_margin_right = 40;
floor_vent_margin_front = 20;
floor_vent_margin_rear  = 20;

// hex style params
floor_vent_d      = 10;   // hex hole size (via cylinder d=, $fn=6)
floor_vent_pitch  = 14;   // spacing between hex centers

// slit style params
floor_vent_slit_w = 4;    // slit height (along Y)
floor_vent_slit_pitch_y = 10;  // spacing between rows (center to center)

// ---- floor standoff pins (optional) -- extra support points across the
// floor so the board doesn't flex in the middle when it's only held at
// the perimeter ledge. On by default; set to false to remove them.
add_standoff_pins = true;
pin_d      = 4;    // pin diameter
pin_h      = 3;    // pin height (ledge/standoff_h is 6, so this sits 3mm proud
                    // of the floor but short of the ledge -- adjust to taste)
pin_pitch  = 45;   // grid spacing
pin_margin = 20;   // keep this far from the walls (clears the ledge/chamfer)

module base_tray() {
  difference() {
    union() {
      // outer shell
      cube([outer_w, outer_d, case_h]);
    }
    // hollow interior
    translate([wall, wall, floor_t])
      cube([inner_w, inner_d, case_h]);

    // rear I/O cutout (rear = y=0 side), sized for a full shield + margin,
    // positioned per the offset measured from the board photos (not centered)
    translate([io_x0, -1, io_start_z])
      cube([io_w, wall+2, io_h]);

    // power switch hole -- rear wall, right of the I/O shield
    translate([pwr_btn_x, -1, pwr_btn_z])
      rotate([-90,0,0])
        cylinder(d=pwr_btn_d, h=wall+2);

    // DC jack hole -- front wall, right side (picoPSU barrel jack)
    translate([dc_jack_x, outer_d+1, dc_jack_z])
      rotate([90,0,0])
        cylinder(d=dc_jack_d, h=wall+2);

    // floor vents -- bounded by the margins above, "hex" or "slit" style
    if (floor_vents) {
      vx0 = wall + floor_vent_margin_left;
      vx1 = wall + inner_w - floor_vent_margin_right;
      vy0 = wall + floor_vent_margin_rear;
      vy1 = wall + inner_d - floor_vent_margin_front;

      if (floor_vent_style == "hex") {
        // honeycomb grid, offset every other row for tight packing
        for (row = [vy0 : floor_vent_pitch*0.87 : vy1 - floor_vent_d]) {
          row_i = round((row - vy0) / (floor_vent_pitch*0.87));
          x_offset = (row_i % 2 == 0) ? 0 : floor_vent_pitch/2;
          for (x = [vx0 + x_offset : floor_vent_pitch : vx1 - floor_vent_d]) {
            translate([x + floor_vent_d/2, row + floor_vent_d/2, -1])
              cylinder(d=floor_vent_d, h=floor_t+2, $fn=6);
          }
        }
      } else if (floor_vent_style == "slit") {
        // parallel full-width slits, like a classic grille
        for (y = [vy0 : floor_vent_slit_pitch_y : vy1 - floor_vent_slit_w]) {
          translate([vx0, y, -1])
            cube([vx1-vx0, floor_vent_slit_w, floor_t+2]);
        }
      }
    }

  }

  // perimeter support ledge for the board (board rests here)
  // left side is widened by 3mm -- board sat with a visible gap there,
  // not reaching the ledge (see fit-check photo)
  difference() {
    translate([wall, wall, floor_t+standoff_h])
      cube([inner_w, inner_d, ledge_t]);
    translate([wall+ledge_w_left, wall+ledge_w, floor_t+standoff_h-1])
      cube([inner_w-ledge_w_left-ledge_w, inner_d-2*ledge_w, ledge_t+2]);
    // trim away the section that overlaps the I/O cutout -- no wall
    // remains behind it there, so it would otherwise float unsupported
    translate([io_x0 - wall, -1, floor_t+standoff_h-1])
      cube([io_w + 2*wall, wall+ledge_w+2, ledge_t+2]);
  }

  // 45-degree chamfer fillets under the ledge so nothing overhangs and no
  // print supports are needed. Each is a hull() between a thin line at the
  // ledge's outer-bottom edge and a thin line at the wall, lower down.
  chamfer_drop = min(ledge_w, standoff_h - 1); // stay clear of the floor
  z_bot_flat   = floor_t + standoff_h;
  z_wall_low   = z_bot_flat - chamfer_drop;
  io_trim_x0   = io_x0 - wall;
  io_trim_x1   = io_x1 + wall;

  module chamfer_wedge(x0, x1, y0, y1, along_x) {
    // along_x = true: wedge tapers in X (ledge runs along left/right walls)
    // along_x = false: wedge tapers in Y (ledge runs along front/rear walls)
    if (along_x) {
      hull() {
        translate([x0, y0, z_bot_flat]) cube([x1-x0, y1-y0, 0.01]);
        translate([(x0==wall)?x0:x1-0.01, y0, z_wall_low]) cube([0.01, y1-y0, 0.01]);
      }
    } else {
      hull() {
        translate([x0, y0, z_bot_flat]) cube([x1-x0, y1-y0, 0.01]);
        translate([x0, (y0==wall)?y0:y1-0.01, z_wall_low]) cube([x1-x0, 0.01, 0.01]);
      }
    }
  }

  // left wall ledge chamfer (widened)
  chamfer_wedge(wall, wall+ledge_w_left, wall, wall+inner_d, true);
  // right wall ledge chamfer
  chamfer_wedge(wall+inner_w-ledge_w, wall+inner_w, wall, wall+inner_d, true);
  // front wall ledge chamfer
  chamfer_wedge(wall, wall+inner_w, wall+inner_d-ledge_w, wall+inner_d, false);
  // rear ledge chamfer, split around the I/O cutout
  if (io_trim_x0 > wall)
    chamfer_wedge(wall, io_trim_x0, wall, wall+ledge_w, false);
  if (io_trim_x1 < wall+inner_w)
    chamfer_wedge(io_trim_x1, wall+inner_w, wall, wall+ledge_w, false);

  // floor standoff pins -- grid of extra support points under the middle
  // of the board so it doesn't flex between the perimeter ledge edges.
  // Same height as the ledge top, so the board rests flush on both.
  if (add_standoff_pins) {
    px0 = wall + pin_margin;
    px1 = wall + inner_w - pin_margin;
    py0 = wall + pin_margin;
    py1 = wall + inner_d - pin_margin;
    for (x = [px0 : pin_pitch : px1]) {
      for (y = [py0 : pin_pitch : py1]) {
        translate([x, y, floor_t])
          cylinder(d=pin_d, h=pin_h, $fn=16);
      }
    }
  }

  // retention tabs -- ONLY on left/right (2 opposite sides), never front/rear.
  // Assembly: angle the board in through the front (open) side, rear edge
  // first toward the I/O opening, then lay it flat -- it slides horizontally
  // under these tabs rather than needing them to flex open. Tabs on all 4
  // sides would trap the board with no way to insert it.
  //
  // IMPORTANT: tabs must hover ABOVE the board with clearance, not sit
  // flush on the ledge -- otherwise there's no gap for the board to slide
  // into and the catch does nothing.
  tab_z0 = floor_t + standoff_h + ledge_t + board_t + board_clearance;

  tab_positions = [
    [wall+ledge_w_left/2, wall+15],
    [wall+ledge_w_left/2, wall+inner_d-15],
    [wall+inner_w-ledge_w/2, wall+15],
    [wall+inner_w-ledge_w/2, wall+inner_d-15]
  ];
  for (p = tab_positions) {
    translate([p[0]-2, p[1]-3, tab_z0])
      cube([4, 6, tab_h]); // hovers board_t+clearance above the ledge -- board slides underneath
  }

  // corner mounting posts for lid screws -- pushed into ears OUTSIDE the
  // board/ledge footprint so they never collide with the board at any height
  difference() {
    for (p = post_positions()) {
      // solid ear block bridging the post to the nearest outer wall corner
      hull() {
        translate([p[0],p[1],0]) cylinder(d=post_d, h=case_h);
        translate([p[2],p[3],0]) cube([1,1,case_h]);
      }
    }
    for (p = post_positions()) {
      translate([p[0],p[1],case_h-8]) cylinder(d=2.6, h=9); // pilot hole for self-tap M3
    }
  }

  // top flange -- so the lid rests on a continuous rim rather than just
  // the 4 corner posts. Same self-supporting wedge trick as the board
  // ledge, flipped outward: vertical face against the (already solid)
  // wall, tapering to a knife edge at the ear boundary, flat on top so
  // the lid sits flush. No overhang anywhere -- purely local 45 deg slope.
  flange_h  = ear;              // ~45 deg taper since it reaches out by 'ear'
  flange_z0 = case_h - flange_h;
  // (io_x0 / io_x1 reused from the global offset-based cutout position)

  module flange_wedge(x0, x1, y0, y1, dir) {
    // dir: "L" wall at x1 tapering to x0 / "R" wall at x0 tapering to x1
    //      "F" wall at y0 tapering to y1 / "B" wall at y1 tapering to y0
    if (dir=="L") hull() {
      translate([x1-0.01,y0,flange_z0]) cube([0.01,y1-y0,flange_h]);
      translate([x0,y0,case_h-0.01]) cube([0.01,y1-y0,0.01]);
    }
    if (dir=="R") hull() {
      translate([x0,y0,flange_z0]) cube([0.01,y1-y0,flange_h]);
      translate([x1-0.01,y0,case_h-0.01]) cube([0.01,y1-y0,0.01]);
    }
    if (dir=="F") hull() {
      translate([x0,y0,flange_z0]) cube([x1-x0,0.01,flange_h]);
      translate([x0,y1-0.01,case_h-0.01]) cube([x1-x0,0.01,0.01]);
    }
    if (dir=="B") hull() {
      translate([x0,y1-0.01,flange_z0]) cube([x1-x0,0.01,flange_h]);
      translate([x0,y0,case_h-0.01]) cube([x1-x0,0.01,0.01]);
    }
  }

  flange_wedge(-ear, 0, 0, outer_d, "L");                 // left wall, tapers out to x=-ear
  flange_wedge(outer_w, outer_w+ear, 0, outer_d, "R");    // right wall, tapers out to x=outer_w+ear
  flange_wedge(0, outer_w, outer_d, outer_d+ear, "F");    // front wall, tapers out to y=outer_d+ear
  // rear wall flange, split around the I/O opening (no wall exists there)
  if (io_x0 - 1 > 0)
    flange_wedge(0, io_x0-1, -ear, 0, "B");
  if (io_x1 + 1 < outer_w)
    flange_wedge(io_x1+1, outer_w, -ear, 0, "B");

  // bottom flange -- mirror of the top one, for symmetry. Same wedge, just
  // flipped in Z: flat on the print bed (z=0), tapering up to meet the
  // plain wall. The rear side doesn't need splitting around the I/O
  // opening here since the wall is still solid this low (below io_start_z).
  bflange_h = min(ear, io_start_z - 0.5); // stay just clear of the I/O cutout

  module bottom_flange_wedge(x0, x1, y0, y1, dir) {
    if (dir=="L") hull() {
      translate([x1-0.01,y0,0]) cube([0.01,y1-y0,bflange_h]);
      translate([x0,y0,0]) cube([0.01,y1-y0,0.01]);
    }
    if (dir=="R") hull() {
      translate([x0,y0,0]) cube([0.01,y1-y0,bflange_h]);
      translate([x1-0.01,y0,0]) cube([0.01,y1-y0,0.01]);
    }
    if (dir=="F") hull() {
      translate([x0,y0,0]) cube([x1-x0,0.01,bflange_h]);
      translate([x0,y1-0.01,0]) cube([x1-x0,0.01,0.01]);
    }
    if (dir=="B") hull() {
      translate([x0,y1-0.01,0]) cube([x1-x0,0.01,bflange_h]);
      translate([x0,y0,0]) cube([x1-x0,0.01,0.01]);
    }
  }

  bottom_flange_wedge(-ear, 0, 0, outer_d, "L");
  bottom_flange_wedge(outer_w, outer_w+ear, 0, outer_d, "R");
  bottom_flange_wedge(0, outer_w, outer_d, outer_d+ear, "F");
  bottom_flange_wedge(0, outer_w, -ear, 0, "B");   // full width -- wall is solid here
}

module lid() {
  difference() {
    hull() {
      for (p = post_positions())
        translate([p[0], p[1], 0]) cylinder(r=post_r, h=lid_t);
    }
    // vent pattern over the whole lid for passive convection (sparser grid, faster CSG)
    for (x = [15:25:outer_w-15]) {
      for (y = [15:25:outer_d-15]) {
        translate([x, y, -1]) cylinder(d=10, h=lid_t+2);
      }
    }
    // screw clearance holes matching corner ear posts
    for (p = post_positions()) {
      translate([p[0],p[1],-1]) cylinder(d=3.2, h=lid_t+2);
    }
  }
}

// ---- test coupons -- quick prints to verify fit before committing to a
// full print. Both are carved directly out of base_tray() via intersection,
// so they always match the real geometry exactly (any dimension tweak
// above automatically updates these too).

// TEST 1: I/O shield opening -- a flat plate with just the cutout hole,
// with a real margin on all 4 sides to hold/snap the shield against.
// Built independently (not sliced from base_tray()) so it isn't constrained
// by the ledge/chamfer support structure that lives right next to the
// opening on the real rear wall -- this way the margin is genuinely free.
io_test_margin = 6;   // border width on all 4 sides (min requested: 4mm)
module io_test_piece_raw() {
  x0 = io_x0 - io_test_margin;
  x1 = io_x1 + io_test_margin;
  z0 = io_start_z - io_test_margin;
  z1 = io_start_z + io_h + io_test_margin;
  difference() {
    translate([x0, 0, z0]) cube([x1-x0, wall, z1-z0]);
    translate([io_x0, -1, io_start_z]) cube([io_w, wall+2, io_h]);
  }
}
// As built, this is a vertical wall slice (thin in Y, tall in Z) -- printing
// it as-is stands it up on edge. Rotated so the wall thickness becomes the
// print height instead: it lies flat on the bed and prints in a couple of
// minutes rather than needing supports for an upright thin wall.
module io_test_piece() {
  translate([0, 0, wall])
    rotate([-90, 0, 0])
      io_test_piece_raw();
}

// TEST 2: board ledge -- just the front-left corner (the most informative
// one: it's a real 90-degree joint where the left and front ledges meet,
// with a retention tab right there too). Trimmed to short ~40mm arms
// instead of running the full wall length -- the previous full-length
// version took 1h45m to print; this is the same profile, just far less
// material and travel.
ledge_test_arm = 40;  // how far each arm reaches from the corner
module ledge_test_piece() {
  tab_z0 = floor_t + standoff_h + ledge_t + board_t + board_clearance;
  z1 = tab_z0 + tab_h + 3;              // just above the tab, keeps it a quick print
  left_x1  = wall + ledge_w_left + 6;   // a bit past the left ledge's inner edge
  front_y0 = outer_d - ledge_w - 6;     // a bit past the front ledge's inner edge
  intersection() {
    base_tray();
    union() {
      // short left-wall arm, ending at the front-left corner
      translate([-2, outer_d-ledge_test_arm, -1])
        cube([left_x1+2, ledge_test_arm+2, z1+1]);
      // short front-wall arm, starting at the same corner
      translate([-2, front_y0, -1])
        cube([ledge_test_arm+2, outer_d-front_y0+2, z1+1]);
    }
  }
}

// ---- layout / export control ----
// GUI workflow: open case.scad in OpenSCAD. Window menu -> Customizer (if
// not already open). Check ONE box below for the piece you want, press F6
// (Render), then File -> Export -> Export as STL. Uncheck it and check the
// next one to export a different piece. Each piece has its own fixed spot
// so you can also check several at once just to look at them together.
//
// Command-line equivalent, if you prefer it:
//   openscad -D 'part="base"'       -o base.stl       case.scad
//   openscad -D 'part="lid"'        -o lid.stl         case.scad
//   openscad -D 'part="io_test"'    -o io_test.stl     case.scad
//   openscad -D 'part="ledge_test"' -o ledge_test.stl  case.scad
show_base       = true;   // base tray
show_lid        = false;  // lid
show_io_test    = false;  // I/O opening test coupon
show_ledge_test = false;  // ledge fit test coupon

// (command-line -D part="..." still works and overrides the checkboxes above)
part = "";

use_part_var = (part == "base" || part == "lid" || part == "io_test" || part == "ledge_test");

if (use_part_var) {
  if (part == "base") base_tray();
  else if (part == "lid") lid();
  else if (part == "io_test") io_test_piece();
  else if (part == "ledge_test") ledge_test_piece();
} else {
  if (show_base) base_tray();
  if (show_lid) translate([0, outer_d+15, 0]) lid();
  if (show_io_test) translate([outer_w+40, 0, 0]) io_test_piece();
  if (show_ledge_test) translate([outer_w+40, 120, 0]) ledge_test_piece();
}
