package
{
    import com.pblabs.engine.PBE;
    import com.pblabs.engine.core.ITickedObject;
    import com.pblabs.engine.core.InputKey;
    import com.pblabs.engine.core.ProcessManager;
    
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.geom.Matrix3D;
    import flash.geom.Point;
    import flash.geom.Utils3D;
    import flash.geom.Vector3D;
    import flash.utils.getTimer;
    
    [SWF(frameRate="120")]
    public class exploringFlash3D extends Sprite implements ITickedObject
    {
        var worldMatrix:Matrix3D = new Matrix3D();
        var projectionMatrix:Matrix3D;
        
        var curX:Number = 100;
        var curZ:Number = 0;
        var yRot:Number = 0;
        
        public function exploringFlash3D()
        {
            PBE.startup(this);
            
            for(var i:int=0; i<1000; i++)
                createParticle(Math.random() * 0xFFFFFF);
            
            ProcessManager.instance.addTickedObject(this);
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
       
        public function onTick(dt:Number):void
        {
            var deltaX:Number = 0, deltaY:Number = 0;
            if(PBE.isKeyDown(InputKey.A))
                deltaX -= 4;
            
            if(PBE.isKeyDown(InputKey.D))
                deltaX += 4;
            
            if(PBE.isKeyDown(InputKey.W))
                deltaY += 4;
            
            if(PBE.isKeyDown(InputKey.S))
                deltaY -= 4;
            
            if(PBE.isKeyDown(InputKey.Q))
                yRot--;
            
            if(PBE.isKeyDown(InputKey.E))
                yRot++;
            
            // Move according to heading.
            var th:Number = (yRot / 90.0) * Math.PI; 
            curX += (Math.cos(th) * deltaX) + (-Math.sin(th) * deltaY);
            curZ += (Math.sin(th) * deltaX) + (Math.cos(th) * deltaY);
            
            var focalLength:Number = 1000;
            
            transform.perspectiveProjection.fieldOfView = 90;
            transform.perspectiveProjection.focalLength = focalLength;
            transform.perspectiveProjection.projectionCenter = new Point(stage.stageWidth / 2, stage.stageHeight / 2);
            
            projectionMatrix = transform.perspectiveProjection.toMatrix3D();
            
            worldMatrix.identity();
            worldMatrix.prependTranslation(curX, 0, curZ);
            worldMatrix.appendRotation(yRot * 2, Vector3D.Y_AXIS);
            
            worldMatrix.append(projectionMatrix);
            
            var screenPos:Vector3D = new Vector3D();
            
            // Position everything.
            for(var i:int=0; i<numChildren; i++)
            {
                var curThing:DO3D = getChildAt(i) as DO3D;
                if(!curThing)
                    continue;

                // Position it based on its transformed position.
                transformVec(worldMatrix, curThing.worldPosition, screenPos);
                var preZ:Number = screenPos.z;
                screenPos.project();

                curThing.x = screenPos.x + stage.stageWidth / 2;
                curThing.y = screenPos.y + stage.stageHeight / 2;
                curThing.visible = preZ < 0;
                
                var scaleFactor:Number = focalLength / preZ;
                curThing.scaleX = scaleFactor;
                curThing.scaleY = scaleFactor;
            }
        }
        
        final public function transformVec(m:Matrix3D, i:Vector3D, o:Vector3D):void
        {
            const x:Number = i.x, y:Number = i.y, z:Number = i.z;
            const d:Vector.<Number> = m.rawData;
            
            o.x = x * d[0] + y * d[4] + z * d[8] + d[12];
            o.y = x * d[1] + y * d[5] + z * d[9] + d[13];
            o.z = x * d[2] + y * d[6] + z * d[10] + d[14];
            o.w = x * d[3] + y * d[7] + z * d[11] + d[15];
        }
    }
}