package
{
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.TimerEvent;
    import flash.utils.Timer;
    
    /**
     * Experiment to compare various ways of interacting with the Flash Player update loop. 
     * @author beng
     */
    [SWF(height="400", width="800", frameRate="20")]
    public class updateLoop extends Sprite
    {
        public var alwaysOnTimer:Timer = new Timer(1000/20);
        public var toggledTimer:Timer = new Timer(1000/20);
        
        public var renderBitmap:LoggerBitmap = new LoggerBitmap("Event.RENDER");
        public var frameBitmap:LoggerBitmap = new LoggerBitmap("Event.ENTER_FRAME");
        public var alwaysOnBitmap:LoggerBitmap = new LoggerBitmap("TimerEvent.TIMER AlwaysOn");
        public var toggledBitmap:LoggerBitmap = new LoggerBitmap("TimerEvent.TIMER Toggled");

        public function updateLoop()
        {
            trace("Starting up...");
            
            addEventListener(Event.RENDER, onRender);
            addEventListener(Event.ENTER_FRAME, onEnterFrame);
            
            alwaysOnTimer.addEventListener(TimerEvent.TIMER, onAlwaysOnTimer);
            toggledTimer.addEventListener(TimerEvent.TIMER, onToggledTimer);
            
            addChild(renderBitmap);
            addChild(frameBitmap); frameBitmap.y = 100;
            addChild(alwaysOnBitmap); alwaysOnBitmap.y = 200;
            addChild(toggledBitmap); toggledBitmap.y = 300;
            
            alwaysOnTimer.start();
            toggledTimer.start();
        }
        
        public function onRender(e:Event):void
        {
            renderBitmap.logElapsed();
            
            frameBitmap.logSync(0x000088, 0);
            alwaysOnBitmap.logSync(0x000088, 0);
            toggledBitmap.logSync(0x000088, 0);
        }
        
        public function onEnterFrame(e:Event):void
        {
            frameBitmap.logElapsed();

            renderBitmap.logSync(0x008800, 1);
            alwaysOnBitmap.logSync(0x08800, 1);
            toggledBitmap.logSync(0x008800, 1);
        }
        
        public function onAlwaysOnTimer(te:TimerEvent):void
        {
            alwaysOnBitmap.logElapsed();

            renderBitmap.logSync(0x880000, 2);
            frameBitmap.logSync(0x880000, 2);
            toggledBitmap.logSync(0x880000, 2);
        }
        
        public function onToggledTimer(te:TimerEvent):void
        {
            toggledTimer.stop();
            
            toggledBitmap.logElapsed();

            renderBitmap.logSync(0x880088, 3);
            frameBitmap.logSync(0x880088, 3);
            alwaysOnBitmap.logSync(0x880088, 3);

            toggledTimer.start();
        }
    }
}