package
{
    import flash.display.Sprite;
    import flash.events.Event;
    
    public class exploringFlash3D extends Sprite
    {
        var spinner:Sprite;
        
        public function exploringFlash3D()
        {
            // Stick a spining sprite on screen.
            spinner = new Sprite();
            addChild(spinner);
            
            spinner.graphics.beginFill(0xFF00FF);
            spinner.graphics.drawRect(-60, -60, 120, 120);
            spinner.graphics.endFill();
            
            spinner.graphics.lineStyle(0, 0x00FF00);
            spinner.graphics.moveTo( -40, -40);
            spinner.graphics.lineTo( 40, 40);

            spinner.graphics.lineStyle(0, 0xFFFFFF);
            spinner.graphics.moveTo( -40,  40);
            spinner.graphics.lineTo( 40, -40);
            
            spinner.x = 100;
            spinner.y = 100;
            
            addEventListener(Event.ENTER_FRAME, onFrame);
        }
        
        public function onFrame(e:*):void
        {
            spinner.rotationX += 1;
            spinner.rotationY += 1;
            spinner.rotationZ += 1;
            spinner.z += 1;
        }
    }
}