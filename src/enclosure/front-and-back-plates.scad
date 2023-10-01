function mm(x) = x;

isDrawingFrontPlate = true;
isProjectionForDxfExport = true;

plateWidth = mm(63.5);
plateHeight = mm(30);
plateThickness = mm(1.6);
plateThroughHole = plateThickness + mm(0.2);
plateEngraving = mm(0.16);

icspConnectorWidth = mm(11.9);
icspConnectorHeight = mm(4.8);
gpioConnectorWidth = mm(40.62);
gpioConnectorHeight = mm(9.1);
circularConnectorRadius = mm(15.74 / 2);

topOfPcb = -mm(5.05);
bottomOfPcb = topOfPcb - mm(1.6);

module frontPlate(plateEngraving) {
	difference() {
		cube([plateWidth, plateHeight, plateThickness], center=true);

		translate([0, topOfPcb + icspConnectorHeight / 2, 0])
			cube([gpioConnectorWidth, gpioConnectorHeight, plateThroughHole], center=true);

	translate([0, gpioConnectorHeight / 2, plateThickness / 2 - plateEngraving])
		linear_extrude(height=plateEngraving + mm(0.1), center=false) text("GPIO", size=4, halign="center", valign="bottom");

	translate([0, -gpioConnectorHeight / 2 - mm(4), plateThickness / 2 - plateEngraving])
		linear_extrude(height=plateEngraving + mm(0.1), center=false) text("pete@restall.net", size=4, halign="center", valign="top");
	}
}

module backPlate(plateEngraving) {
	difference() {
		cube([plateWidth, plateHeight, plateThickness], center=true);

		translate([-mm(11), mm(2.2), 0])
			cylinder(h=plateThroughHole, r=circularConnectorRadius, center=true);

		translate([mm(11), mm(2.2), 0])
			cylinder(h=plateThroughHole, r=circularConnectorRadius, center=true, $fn=360);

		translate([0, bottomOfPcb - icspConnectorHeight / 2, 0])
			cube([icspConnectorWidth, icspConnectorHeight, plateThroughHole], center=true, $fn=360);

	translate([-mm(10), bottomOfPcb - icspConnectorHeight / 2, plateThickness / 2 - plateEngraving])
		linear_extrude(height=plateEngraving + mm(0.1), center=false) text("PWR", size=4, halign="right", valign="center");

	translate([mm(10), bottomOfPcb - icspConnectorHeight / 2, plateThickness / 2 - plateEngraving])
		linear_extrude(height=plateEngraving + mm(0.1), center=false) text("LEDs", size=4, halign="left", valign="center");
	}
}

module drawPart(plateEngraving=plateEngraving) {
	if (isDrawingFrontPlate)
		frontPlate(plateEngraving);
	else
		backPlate(plateEngraving);
}

if (isProjectionForDxfExport)
	projection(cut=false) drawPart(plateEngraving=plateThroughHole);
else
	drawPart();
