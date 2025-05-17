module PointsStorage   
    require 'securerandom'   
    @points = {}

    class << self

        def setPoints(points)
            id = generateId
            @points[id] = points
            return id
        end

        def getPoints(id)
            @points[id]
        end
        
        private
        def generateId     
            uuid = SecureRandom.uuid
            uuid = SecureRandom.uuid while !@points[uuid].nil?
            return uuid
        end

    end
end