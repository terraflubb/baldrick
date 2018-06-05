package baldrick;

/**
  A collection of processors which will be processed
  together in a single `process` call.
*/
@:allow(baldrick.Universe)
class Phase {
    private var universe:Universe;

    /**
      The processors grouped in this phase
    */
    public var processors:Array<Processor>;

    #if profiling
    /**
      The total time taken to run this phase

      **Note:** only generated when `profiling` is defined
    */
    public var profileTime(default, null):Float = 0.0;
    
    /**
      The times of each individual processor

      **Note:** only generated when `profiling` is defined
    */
    public var processorTimes(default, null):haxe.ds.StringMap<Float> = new haxe.ds.StringMap<Float>();
    #end

    public function new(universe:Universe) {
        this.universe = universe;
        processors = new Array<Processor>();
        universe.phases.push(this);
    }

    /**
      Call `process` on all grouped processors
    */
    public function process():Void {
        #if profiling
        var startT:Float = haxe.Timer.stamp();
        #end
        for(processor in processors) {
            #if profiling
            processor.profileProcess();
            processorTimes.set(processor.profileName, processor.profileTime);
            #else
            processor.process();
            #end
        }
        #if profiling
        profileTime = haxe.Timer.stamp() - startT;
        #end
    }

    /**
      Add a processor to this phase
      @param processor the processor to add
      @return Phase
    */
    public function addProcessor(processor:Processor):Phase {
        processors.push(processor);
        return this;
    }
}