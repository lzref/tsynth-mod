showTopPanelLeft = false;
showTopPanelRight = false;
showBottomEnclosureLeft = false;
showBottomEnclosureRight = true;

$fn = 360;

dd = 1;

topPanelThickness = 3;
sideWallThickness = 3;
floorThickness = 2;

caseSizeX = 400;
caseSizeY = 160;
caseSizeZ = 30;

sideScrewHoleDiam = 2.7;
//sideScrewHoleVertOffset = 2.5;
sideScrewHoleHorizOffset = sideScrewHoleDiam + 0.5;

middleScrewHoleDiam = 3;
middleScrewHorizOffset = 4;
middleScrewVertOffset = 7;

cablesHoleWidth = 20;
cablesHoleHeight = 20;

usbHostJackWidth = 13.5;
usbHostJackHeight = 6;
usbHostOffset = 80;

usbBJackWidth = 12;
usbBJackHeight = 11;
usbBOffset = 30;

midiJackDiam = 20;
midiJack1Offset = -caseSizeX / 3;
midiJack2Offset = -caseSizeX / 6;

jacksOffsetFromBottom = 12;

smallAudioJackDiam = 6;
smallAudioJackOffset = 120;

lipWidth = 3;
lipHeight = 4;

module sideScrewHoleAlongX(y)
{
    color("cyan")
        translate([-caseSizeX / 4 - dd, y, -lipHeight / 2])
            rotate(90, [0, 1, 0])
                cylinder(d = sideScrewHoleDiam, h = caseSizeX / 2 + 2 * dd);
}

module sideScrewHoleAlongY(x)
{
    color("cyan")
        translate([x, caseSizeY / 2 + dd, -lipHeight / 2])
            rotate(90, [1, 0, 0])
                cylinder(d = sideScrewHoleDiam, h = caseSizeY + 2 * dd);
}

module lip(outlineSizeX, outlineSizeY, sideWallThickness, lipWidth, lipHeight)
{
    color("red") {
        translate([
            -outlineSizeX / 2 + sideWallThickness,
            -outlineSizeY / 2 + sideWallThickness,
            -lipHeight
        ])
            cube([
                outlineSizeX - 2 * sideWallThickness,
                lipWidth,
                lipHeight
            ]);
        
        translate([
            -outlineSizeX / 2 + sideWallThickness,
            -outlineSizeY / 2 + sideWallThickness,
            -lipHeight
        ])
            cube([
                lipWidth,
                outlineSizeY - 2 * sideWallThickness,
                lipHeight
            ]);
            
            
        translate([
            -outlineSizeX / 2 + sideWallThickness,
            outlineSizeY / 2 - sideWallThickness - lipWidth,
            -lipHeight
        ])
            cube([
                outlineSizeX - 2 * sideWallThickness,
                lipWidth,
                lipHeight
            ]);
        
        translate([
            outlineSizeX / 2 - sideWallThickness - lipWidth,
            -outlineSizeY / 2 + sideWallThickness,
            -lipHeight
        ])
            cube([
                lipWidth,
                outlineSizeY - 2 * sideWallThickness,
                lipHeight
            ]);
    }
}

module sideScrewHoles(outlineSizeX)
{
    offsetFromCenterX = outlineSizeX / 2 - sideWallThickness - lipWidth
        - sideScrewHoleHorizOffset;
    
    sideScrewHoleAlongY(-offsetFromCenterX);
    sideScrewHoleAlongY(0);
    sideScrewHoleAlongY(offsetFromCenterX);
    
    sideScrewHoleAlongX(0);
}

module lipWithHoles(outlineSizeX, outlineSizeY, sideWallThickness, lipWidth, lipHeight)
{
    offsetFromCenterX = outlineSizeX / 2 - sideWallThickness - lipWidth
        - sideScrewHoleHorizOffset;
    
    difference() {
        lip(outlineSizeX, outlineSizeY, sideWallThickness, lipWidth, lipHeight);
        
        sideScrewHoles(outlineSizeX);
    }
}

module topPanel()
{
    linear_extrude(height = topPanelThickness, center = false)
        difference()
        {
            square([caseSizeX, caseSizeY], center = true);
            import("panel holes.svg", center = true, dpi = 600);
        }
}

module topPanelLeft()
{
    difference()
    {
        topPanel();
        
        translate([500, 0, 0])
            cube([1000, 1000, 1000], center = true);
    }
    
    translate([-caseSizeX / 4, 0, 0])
        lipWithHoles(
            caseSizeX / 2,
            caseSizeY,
            sideWallThickness,
            lipWidth,
            lipHeight
        );
}

module topPanelRight()
{
    intersection()
    {
        topPanel();
        
        translate([500, 0, 0])
            cube([1000, 1000, 1000], center = true);
    }
    
    translate([caseSizeX / 4, 0, 0])
        lipWithHoles(
            caseSizeX / 2,
            caseSizeY,
            sideWallThickness,
            lipWidth,
            lipHeight
        );
}

module walls(sizeX, sizeY, wallThickness, wallHeight)
{
    color("blue")
        difference() {
            cube([sizeX, sizeY, wallHeight]);
            
            translate([wallThickness, wallThickness, -dd])
                cube([
                    sizeX - wallThickness * 2,
                    sizeY - wallThickness * 2,
                    wallHeight + 2 * dd
                ]);
        }
}

module middleScrewHole(y, z)
{
    color("brown")
        translate([-sideWallThickness - dd, y, z])
            rotate(90, [0, 1, 0])
                cylinder(
                    d = middleScrewHoleDiam,
                    h = (sideWallThickness + dd) * 2
                );
}

module middleHoles()
{
    middleScrewHole(0, -caseSizeZ + middleScrewVertOffset);
    middleScrewHole(
        -caseSizeY / 2 + sideWallThickness + middleScrewHorizOffset,
        -caseSizeZ + middleScrewVertOffset
    );
    middleScrewHole(
        caseSizeY / 2 - sideWallThickness - middleScrewHorizOffset,
        -caseSizeZ + middleScrewVertOffset
    );
    
    middleScrewHole(0, - middleScrewVertOffset);
    middleScrewHole(
        -caseSizeY / 2 + sideWallThickness + middleScrewHorizOffset,
        - middleScrewVertOffset
    );
    middleScrewHole(
        caseSizeY / 2 - sideWallThickness - middleScrewHorizOffset,
        - middleScrewVertOffset
    );
    
    
    translate([0, - caseSizeY / 4, - cablesHoleHeight / 2])
        cube(
            [
                (sideWallThickness + dd) * 2,
                cablesHoleWidth,
                cablesHoleHeight + dd
            ],
            center = true
        );
}

module usbBHole()
{
    rectangularJack(usbBOffset, usbBJackWidth, usbBJackHeight);
}

module usbHostHole()
{
    rectangularJack(usbHostOffset, usbHostJackWidth, usbHostJackHeight);
}

module rectangularJack(x, width, height)
{
    color("white")
        translate([
            x,
            caseSizeY / 2 - sideWallThickness / 2,
            -caseSizeZ + jacksOffsetFromBottom
        ])
            cube(
                [width, sideWallThickness + 2 * dd, height],
                center = true
            );
}

module roundJack(x, diam)
{
    color("white")
        translate([
            x,
            caseSizeY / 2 - sideWallThickness / 2,
            -caseSizeZ + jacksOffsetFromBottom
        ])
            rotate(90, [1, 0, 0])
                cylinder(d = diam, h = sideWallThickness + 2 * dd, center = true);
}

module smallAudioHole()
{
    roundJack(smallAudioJackOffset, smallAudioJackDiam);
}

module midiHole1()
{
    roundJack(midiJack1Offset, midiJackDiam);
}

module midiHole2()
{
    roundJack(midiJack2Offset, midiJackDiam);
}

module jackHoles()
{
    usbHostHole();
    usbBHole();
    smallAudioHole();
    midiHole1();
    midiHole2();
}

module floor()
{
    translate([0, - caseSizeY / 2, - caseSizeZ - floorThickness])
        cube([caseSizeX / 2, caseSizeY, floorThickness]);
}

module bottomEnclosureLeft()
{
    difference() {
        translate([- caseSizeX / 2, -caseSizeY / 2, -caseSizeZ])
            walls(caseSizeX / 2, caseSizeY, sideWallThickness, caseSizeZ);
        
        translate([- caseSizeX / 4, 0, 0])
            sideScrewHoles(caseSizeX / 2);
        
        middleHoles();
        
        jackHoles();
    }
    
    translate([-caseSizeX / 2, 0, 0])
        floor();
}

module bottomEnclosureRight()
{
    difference() {
        translate([0, -caseSizeY / 2, -caseSizeZ])
            walls(caseSizeX / 2, caseSizeY, sideWallThickness, caseSizeZ);
        
        translate([caseSizeX / 4, 0, 0])
            sideScrewHoles(caseSizeX / 2);
        
        middleHoles();
        
        jackHoles();
    }
    
    floor();
}

if (showTopPanelLeft) {
    topPanelLeft();
}

if (showTopPanelRight) {
    topPanelRight();
}

if (showBottomEnclosureLeft) {
    bottomEnclosureLeft();
}

if (showBottomEnclosureRight) {
    bottomEnclosureRight();
}
