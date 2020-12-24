package eventbeacon ;

/**
 * ...
 * @author 
 */
class Beacon
{
	private var listeners: Map<String, Array<Event -> Void>>;
	
	private function addToMap(map: Map < String, Array < Event -> Void >>, eventName, fn: Event -> Void) {
		if (map.exists(eventName)) {
			var value = map.get(eventName);
			value.push(fn);
			map.set(eventName, value);
		} else {
			var arr = new Array<Event -> Void>();
			arr.push(fn);
			map.set(eventName, arr);
		}
	}
	
	public function new() 
	{
		listeners = new Map<String, Array<Event -> Void>>();
	}
	
	/**
	 * Adds an event listener to the beacon
	 * 
	 * @param	name
	 * @param	fn
	 */
	public function on(name: String, fn: Event -> Void) {
		addToMap(listeners, name, fn);
	}
	
	/**
	 * Removes all events with the specified name
	 * 
	 * @param	name
	 */
	public function off(name: String) {
		listeners.remove(name);
	}
	
	public function exists(name: String) {
		
	}
	
	/**
	 * Triggers all events with the specified name
	 * 
	 * @param	name
	 * @param	event
	 */
	public function trigger(name: String, ?event: Dynamic) {	
		var eventInstance = Type.getClass(event);
		var ev = (eventInstance != null && Type.getClassName(eventInstance) == 'eventbeacon.Event') ? event : new Event(event);
		ev.sender = this;
		
		var listener = listeners.get(name);
		
		for (i in listener) {
			i.bind(ev)();
		}
	}
}