class ReceiptsController < ApplicationController
    skip_before_action :verify_authenticity_token
    include ReceiptsHelper

    def process_reciept
        payload = JSON.parse(request.body.read)
        filtered_payload = filterPayload(payload)
        id = asignPoints(filtered_payload)
        render json: {"id": id}
    end

    def points
        render json: {"points": PointsStorage.getPoints(paramsId)}
    end

    private

    def filterPayload(payloadHash)
        filteredPayload = {
            "retailer": payloadHash["retailer"],
            "purchaseDate": payloadHash["purchaseDate"],
            "purchaseTime": payloadHash["purchaseTime"], 
            "items": payloadHash["items"].map do |item| {"shortDescription": item["shortDescription"], "price": item["price"]} end,
            "total": payloadHash["total"]
        }
    end

    def paramsId
        params.require("id")
    end

end
