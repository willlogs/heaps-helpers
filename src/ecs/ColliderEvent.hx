package ecs;

class ColliderEvent {
    public var funcList = new List<Collider->Void>();

    public function new(){

    }

    public function call(c:Collider){
        for(func in funcList){
            func(c);
        }
    }
}