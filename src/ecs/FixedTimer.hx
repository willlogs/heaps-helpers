package ecs;

import haxe.Timer;

class FixedTimer extends Timer {
    public var hooks : List<() -> Void>;

    public function new(time:Int) {
        super(time);
        hooks = new List<() -> Void>();
    }

    override function run() {
        for (func in hooks){
            func();
        }
    }
}