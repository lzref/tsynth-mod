showTopPanelLeft = true;
showTopPanelRight = true;

$fn = 360;

dd = 1;

topPanelThickness = 3;
sideWallThickness = 3;

caseSizeX = 400;
caseSizeY = 160;
caseSizeZ = 30;

sideScrewHoleDiam = 2.7;
//sideScrewHoleVertOffset = 2.5;
sideScrewHoleHorizOffset = sideScrewHoleDiam + 0.5;

lipWidth = 3;
lipHeight = 4;

module sideScrewHoleAlongX(y)
{
    color("cyan")
        translate([-caseSizeX / 4, y, -lipHeight / 2])
            rotate(90, [0, 1, 0])
                cylinder(d = sideScrewHoleDiam, h = caseSizeX / 2);
}

module sideScrewHoleAlongY(x)
{
    color("cyan")
        translate([x, caseSizeY / 2, -lipHeight / 2])
            rotate(90, [1, 0, 0])
                cylinder(d = sideScrewHoleDiam, h = caseSizeY);
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

module lipWithHoles(outlineSizeX, outlineSizeY, sideWallThickness, lipWidth, lipHeight)
{
    offsetFromCenterX = outlineSizeX / 2 - sideWallThickness - lipWidth
        - sideScrewHoleHorizOffset;
    
    difference() {
        lip(outlineSizeX, outlineSizeY, sideWallThickness, lipWidth, lipHeight);
        
        sideScrewHoleAlongY(-offsetFromCenterX);
        sideScrewHoleAlongY(0);
        sideScrewHoleAlongY(offsetFromCenterX);
        
        sideScrewHoleAlongX(0);
    }
}

module topPanel()
{
    linear_extrude(height = topPanelThickness, center = false)
        difference()
        {
            import("panel.svg", center = true, dpi = 600);
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

if (showTopPanelLeft) {
    topPanelLeft();
}

if (showTopPanelRight) {
    topPanelRight();
}
