class Zips
    def self.all(prototype = {}, sort={:population => 1}, offset = 0, limit=100)
        tmp = {}
        sort.each do |k,v|
            k = k.to_sym == :population ? :pop : k.to_sym
            tmp[k] = v if [:city, :state, :pop].include?(k)
        end
        sort = tmp
        prototype = prototype.symbolize_keys.slice(:city, :state) if !prototype.nil?
        Rails.logger.debug {"getting all zips, prototype=#{prototype}, sort=#{sort}, offset=#{offset}, limit=#{limit}"}
        
        result = collection.find(prototype)
            .projection({ _id: true, city: true, state: true, pop: true})
            .sort(sort)
            .skip(offset)
            
        result = result.limit(limit) if !limit.nil?
        
        return result
    end
    
    
    
    # convinience method for access to client in console
    def self.mongo_client
        Mongoid::Clients.default
    end
    
    # Convinience method for access to zips collection
    
    def self.collection
        self.mongo_client['zips']
    end

end