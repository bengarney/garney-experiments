package
{
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    
    public class LoggerBitmap extends Bitmap
    {
        public function LoggerBitmap()
        {
            super(new BitmapData(400, 100));
        }
        
        public function log(value:int):void
        {
            bitmapData.scroll(1, 0);
            bitmapData.setPixel(value, 0, 0xFF0000);
        }
    }
}