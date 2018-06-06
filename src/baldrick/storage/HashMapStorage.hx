package baldrick.storage;

import haxe.ds.IntMap;
import haxe.Constraints;
import baldrick.Universe;
import baldrick.Component;
import baldrick.Storage;

@:generic
class HashMapStorage<T:(Component, Constructible<Void->Void>)> implements Storage<T> {
    private var map:IntMap<T>;

    public function new() {
        map = new IntMap<T>();
    }

    public function has(entity:Entity):Bool {
        return map.exists(entity);
    }

    public function get(entity:Entity):T {
        return map.get(entity);
    }

    public function addTo(universe:Universe, entity:Entity, notifyUniverse:Bool=true):T {
        map.set(entity, new T());
        if(notifyUniverse) {
            universe.onComponentsAdded(entity);
        }
        return map.get(entity);
    }

    public function removeFrom(universe:Universe, entity:Entity, notifyUniverse:Bool=true):Void {
        if(map.remove(entity) && notifyUniverse) {
            universe.onComponentsRemoved(entity);
        }
    }
}