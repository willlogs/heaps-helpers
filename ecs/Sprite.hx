package ecs;

import h2d.Bitmap;
import h2d.Anim;

class Sprite extends Component{
    var bmp : Bitmap;
    public function new(attachee:GameObject, tile:h2d.Tile){
        super(attachee);

        type = "Sprite";
        this.bmp = new Bitmap(tile);
        bmp.setPosition(attachee.obj.x, attachee.obj.y);
        bmp.rotation = attachee.obj.rotation;

        scene.addChild(bmp);
    }

    public override function update(dt:Float){
        bmp.setPosition(attachee.obj.x, attachee.obj.y);
        bmp.rotation = attachee.obj.rotation;

        // for the test game - remove if you're coding a new game
        if(bmp.y < 0 || bmp.y > scene.height){
            kill();
        }
    }

    public function kill() {
        trace("removing");
        scene.removeChild(bmp);
        Main.UpdateList.remove(attachee);
    }
}