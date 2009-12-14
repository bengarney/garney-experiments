package
{
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.geom.Matrix3D;
    import flash.geom.Point;
    import flash.geom.Vector3D;
    import flash.utils.getTimer;
    
    [SWF(frameRate="120")]
    public class exploringFlash3D extends Sprite
    {
        var spinner:Sprite;
        var worldMatrix:Matrix3D = new Matrix3D();
        var projectionMatrix:Matrix3D;
        
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
                createParticle(Math.random() * 0xFFFFFF);
            
            addEventListener(Event.ENTER_FRAME, onFrame);
        }
        
        public function createParticle(color:uint):void
        {
            var particle:DO3D = new DO3D();
            
            particle.graphics.beginFill(color, 0.5);
            particle.graphics.drawCircle(0, 0, 32);
            particle.graphics.endFill();
            
            particle.worldPosition.x = Math.random() * 200 - 100;
            particle.worldPosition.y = Math.random() * 200 - 100;
            particle.worldPosition.z = Math.random() * 200 - 100;
            
            addChild(particle);
        }
       
        public function onFrame(e:*):void
        {
            projectionMatrix = transform.perspectiveProjection.toMatrix3D();
            
            worldMatrix.identity();
            worldMatrix.appendTranslation(0, 0, -100);
            worldMatrix.appendRotation(getTimer() / 100, new Vector3D(0, 1, 0));
            
            worldMatrix.append(projectionMatrix);
            
            // Position everything.
            for(var i:int=0; i<numChildren; i++)
            {
                var curThing:DO3D = getChildAt(i) as DO3D;
                if(!curThing)
                    continue;
                
                // Position it based on its transformed position.
                var screenPos:Vector3D = worldMatrix.transformVector(curThing.worldPosition);
                var size:Number = 1;
                screenPos.project();
                
                curThing.x = screenPos.x;
                curThing.y = screenPos.y;
                curThing.scaleX = size;
                curThing.scaleY = size;
            }
        }
    }
}