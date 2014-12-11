require 'redis'

# An experiment to get to know Redis's capabilities.
# Directly use redis to put a job onto a queue (the representation of which is
# glossed over -- e.g. string or whatever), simulate starting a job, and
# simulate finishing or failing it.

module Krikri
  class RedisTest
    
    def initialize
      @redis = Redis.new  # Assume localhost & default port
    end

    def enqueue(queuename, value)
      @redis.rpush(queuename, value)
    end

    # Get a job from the waiting queue and move it to the processing queue
    def get(queuename)
      @redis.rpoplpush(queuename, 'processing')
      # returns the value of the element moved to the 'processing' list
    end

    # Fail a job and send its element back to the given queue.
    # It would be easier if there were separate processing queues for separate
    # workers, but that would probably be harder to keep track of.
    # Should the destination queue be a special one for failures?  If the job
    # failed, it may not want to be retried.  This depends on the type of
    # faliure.
    def fail(dest_queuename, job)
      @redis.multi do |m|
        m.lrem('processing', 0, job)
        m.lpush(dest_queuename, job)
      end
    end

    def finish(job)
      @redis.lrem('processing', 0, job)
    end

  end
end