package eventbeacon;

class Event
{
	public var sender: Dynamic;
	public var data: Dynamic;
	public var timestamp: Date;
	
	public function new(?data, ?sender)
	{
		this.sender = sender;
		this.data = data;
		this.timestamp = Date.now();
	}
	
}