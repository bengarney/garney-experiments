package
{
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Sprite;
    import flash.geom.Rectangle;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.utils.getTimer;
    
    /**
     * Helper class to manage a bitmap charting time between calls. Too-long values are shown
     * as red columns.
     * @author beng
     * 
     */
    public class LoggerBitmap extends Sprite
    {
        public var lastTime:int = 0;
        public var captionTF:TextField = new TextField();
        public var bitmap:Bitmap;

        public function LoggerBitmap(caption:String = "unknown")
        {
            super();
            
            bitmap = new Bitmap(new BitmapData(800, 100, false, 0x0));
            addChild(bitmap);
            
            captionTF.textColor = 0x999999;
            captionTF.text = caption;
            captionTF.autoSize = TextFieldAutoSize.LEFT;
            addChild(captionTF);
        }
        
        /**
         * Plots a value on the chart, if it is over 200 it draws a red column.
         */
        public function log(value:int):void
        {
            const pos:int = bitmap.bitmapData.width - 2;
            bitmap.bitmapData.scroll(-1, 0);
            bitmap.bitmapData.fillRect(new Rectangle(bitmap.bitmapData.width - 1, 0, 1, 100), 0x0);
            
            if(value < 200)
                bitmap.bitmapData.setPixel(pos, value >> 1, 0xFFFF00);
            else
            {
                // Set the whole column red.
                for(var i:int=0; i<bitmap.bitmapData.height / 2; i++)
                    bitmap.bitmapData.setPixel(pos, i, 0xFF0000);
            }
        }
        
        
        /**
         * Plots time since last call to logElapsed();. 
         */
        public function logElapsed():void
        {
            var curTime:int = getTimer();
            
            log(curTime - lastTime);
            
            lastTime = curTime;
        }
        
        public function logSync(color:int = 0x008800, quadrant:int = 0):void
        {
            // Set the whole column.
            var oneQuarter:int = 25;
            for(var i:int=oneQuarter*quadrant; i<oneQuarter*(quadrant+1); i++)
                bitmap.bitmapData.setPixel(bitmap.bitmapData.width - 1, i, color);
        }
    }
}