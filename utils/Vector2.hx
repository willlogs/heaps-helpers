package utils;

class Vector2{
    public var x:Float;
    public var y:Float;

    public function new(x:Float = 0, y:Float = 0){
        this.x = x;
        this.y = y;
    }

    public function Normalized():Vector2{
        var abs = Math.sqrt(x*x + y*y);
        return new Vector2(x/abs, y/abs);
    }

    public function NeutralizeBy(v:Vector2){
        
    }
}