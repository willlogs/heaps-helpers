package ecs;

import utils.Vector2;
import h2d.Tile;

class Animation extends Component {
    public var hasSprite : Bool = false;

    private var fps : Int = 5;
    private var sheet : Array<Tile>;
    private var spriteRenderer : Sprite;

    private var frameCount : Int = 0;
    private var frameIndex : Int = 0;

    public function new(attachee_:GameObject, spriteSheet:Tile, tw:Int, th:Int, fps:Int, offset:Vector2){
        super(attachee_);

        this.spriteRenderer = cast(attachee_.GetComponent("Sprite"), Sprite);
        hasSprite = this.spriteRenderer != null;

        this.fps = fps;

        if(hasSprite){
            this.sheet = [
                for(y in 0...Std.int(spriteSheet.height/th))
                    for(x in 0...Std.int(spriteSheet.width/tw))
                        spriteSheet.sub(x * tw, y * th, tw, th)
            ];
        }

        for (spritePart in sheet) {
            spritePart.dx = -tw/2 + offset.x;
            spritePart.dy = -th/2 + offset.y;
        }

        spriteRenderer.bmp.tile = sheet[0];
        frameIndex = 1;
    }

    public override function preUpdate(dt:Float) {
    }

    public override function update(dt:Float){
        if(hasSprite){
            if(frameCount >= fps){
                frameCount = 0;
                spriteRenderer.bmp.tile = sheet[frameIndex++];
                frameIndex %= sheet.length;
            }

            frameCount++; 
        }       
    }

    public override function afterUpdate(dt:Float) {
        
    }

    public override function fixedUpdate() {
        
    }
}