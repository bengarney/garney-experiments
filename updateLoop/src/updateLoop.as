package
{
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.KeyboardEvent;
    import flash.events.TimerEvent;
    import flash.ui.Keyboard;
    import flash.utils.Timer;
    import flash.utils.getTimer;
    
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

        public var enableRender:Boolean = true;
        public var enableFrame:Boolean = true;
        public var enableAlwaysOn:Boolean = true;
        public var enableToggled:Boolean = true;
        public var enableStageInvalidate:Boolean = true;
        public var enableUpdateAfter:Boolean = true;
        public var enableWork:Boolean = true;
        public var workLoad:int = 10;
        
        /**
         * Initialize the application. 
         */
        public function updateLoop()
        {
            trace("Starting up...");

            // Event listeners for various techniques.
            addEventListener(Event.RENDER, onRender);
            addEventListener(Event.ENTER_FRAME, onEnterFrame);
            alwaysOnTimer.addEventListener(TimerEvent.TIMER, onAlwaysOnTimer);
            toggledTimer.addEventListener(TimerEvent.TIMER, onToggledTimer);
            
            // Show the timelines.
            addChild(renderBitmap);
            addChild(frameBitmap); frameBitmap.y = 100;
            addChild(alwaysOnBitmap); alwaysOnBitmap.y = 200;
            addChild(toggledBitmap); toggledBitmap.y = 300;
            
            // User input handlers.
            stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);

            // Start the timers.
            alwaysOnTimer.start();
            toggledTimer.start();
        }
        
        
        /**
         * Handle user input.
         */
        public function onKeyDown(ke:KeyboardEvent):void
        {
            // 1 - toggle RENDER
            // 2 - toggle FRAME
            // 3 - toggle ALWAYS ON
            // 4 - toggle TOGGLED
            // q - toggle stage.invalidate();
            // w - toggle te.updateAfterEvent();
            // s - toggle workload
            // a - increase workload
            // z - decrease workload
            
            // Toggle listeners for each mode.
            if(ke.keyCode == 49) // 1
            {
                if(enableRender)
                {
                    trace("disabling RENDER handler.");
                    enableRender = false;
                }
                else
                {
                    trace("enabling RENDER handler.");
                    enableRender = true;
                }
            }
            else if(ke.keyCode == 50) // 2
            {
                if(enableFrame)
                {
                    trace("disabling FRAME handler.");
                    enableFrame = false;
                }
                else
                {
                    trace("enabling FRAME handler.");
                    enableFrame = true;
                }
            }
            else if(ke.keyCode == 51) // 3
            {
                if(enableAlwaysOn)
                {
                    trace("disabling ALWAYS ON handler.");
                    enableAlwaysOn = false;
                }
                else
                {
                    trace("enabling ALWAYS ON handler.");
                    enableAlwaysOn = true;
                }
            }
            else if(ke.keyCode == 52) // 4
            {
                if(enableToggled)
                {
                    trace("disabling TOGGLED handler.");
                    enableToggled = false;
                }
                else
                {
                    trace("enabling TOGGLED handler.");
                    enableToggled = true;
                }
            }
            else if(ke.keyCode == 81) // q
            {
                if(enableStageInvalidate)
                {
                    trace("disabling stage.invalidate(); calls");
                    enableStageInvalidate = false;
                }
                else
                {
                    trace("enabling stage.invalidate(); calls");
                    enableStageInvalidate = true;
                }
            }
            else if(ke.keyCode == 87) // w
            {
                if(enableUpdateAfter)
                {
                    trace("disabling te.updateAfterEvent(); calls");
                    enableUpdateAfter = false;
                }
                else
                {
                    trace("enabling te.updateAfterEvent(); calls");
                    enableUpdateAfter = true;
                }                
            }
            else if(ke.keyCode == 83) // s
            {
                if(enableWork)
                {
                    trace("disabling workload");
                    enableWork = false;                    
                }
                else
                {
                    trace("enabling workload");
                    enableWork = true;
                }
            }
            else if(ke.keyCode == 65) // a
            {
                workLoad++;
                trace("Incrementing workload to " + workLoad);
            }
            else if(ke.keyCode == 90) // z
            {
                workLoad--;
                trace("Decrementing workload to " + workLoad);                
            }
            else
            {
                trace("Unknown keycode " + ke.keyCode);
            }
            
            // 
            
        }
        /**
         * Handle Event.RENDER.
         */
        public function onRender(e:Event):void
        {
            if(!enableRender)
                return;
            
            workload();

            renderBitmap.logElapsed();
            
            frameBitmap.logSync(0x000088, 0);
            alwaysOnBitmap.logSync(0x000088, 0);
            toggledBitmap.logSync(0x000088, 0);

            if(enableStageInvalidate) stage.invalidate();
        }
        
        /**
         * Handle Event.ENTER_FRAME
         */
        public function onEnterFrame(e:Event):void
        {
            if(!enableFrame)
                return;

            workload();

            frameBitmap.logElapsed();

            renderBitmap.logSync(0x008800, 1);
            alwaysOnBitmap.logSync(0x08800, 1);
            toggledBitmap.logSync(0x008800, 1);

            if(enableStageInvalidate) stage.invalidate();
        }
        
        /**
         * Handle timer we always leave on.
         */
        public function onAlwaysOnTimer(te:TimerEvent):void
        {
            if(!enableAlwaysOn)
                return;

            workload();

            alwaysOnBitmap.logElapsed();

            renderBitmap.logSync(0x880000, 2);
            frameBitmap.logSync(0x880000, 2);
            toggledBitmap.logSync(0x880000, 2);

            if(enableUpdateAfter) te.updateAfterEvent();
            if(enableStageInvalidate) stage.invalidate();
        }
        
        /**
         * Handle timer we stop while processing.
         */
        public function onToggledTimer(te:TimerEvent):void
        {
            if(!enableToggled)
                return;

            // Stop timer while we do our work.
            toggledTimer.stop();
            
            workload();
            
            toggledBitmap.logElapsed();

            renderBitmap.logSync(0x880088, 3);
            frameBitmap.logSync(0x880088, 3);
            alwaysOnBitmap.logSync(0x880088, 3);

            toggledTimer.start();
            
            if(enableUpdateAfter) te.updateAfterEvent();
            if(enableStageInvalidate) stage.invalidate();
        }
        
        public function workload():void
        {
            if(!enableWork)
                return;
            
            var t:int = getTimer();
            while(getTimer() - t < workLoad)
                continue;
        }
    }
}