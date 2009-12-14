package
{
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.geom.Vector3D;
    
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
            
            for(var i:int=0; i<1000; i++)
                createParticle(null, Math.random() * 0xFFFFFF);
            
            addEventListener(Event.ENTER_FRAME, onFrame);
        }
        
        public function createParticle(pos:Vector3D, color:uint):void
        {
            var particle:Sprite = new Sprite();
            
            particle.graphics.beginFill(color, 0.5);
            particle.graphics.drawCircle(0, 0, 32);
            particle.graphics.endFill();
            
            particle.x = Math.random() * 200 - 100;
            particle.y = Math.random() * 200 - 100;
            particle.z = Math.random() * 200 - 100;
            
            spinner.addChild(particle);
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