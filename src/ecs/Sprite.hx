package ecs;

import h2d.Bitmap;

class Sprite extends Component{
    public var bmp : Bitmap;

    public function new(attachee:GameObject, tile:h2d.Tile){
        super(attachee);

        type = "Sprite";
        this.bmp = new Bitmap(tile);
        bmp.rotation = attachee.obj.rotation;

        attachee.obj.addChild(bmp);
    }

    public function kill() {
        trace("removing");
        attachee.obj.removeChild(bmp);
        Main.UpdateList.remove(attachee);
    }
}