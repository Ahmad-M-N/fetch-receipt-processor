require "test_helper"
class ReceiptsControllerTest < ActionDispatch::IntegrationTest
  self.use_transactional_tests = false if respond_to?(:use_transactional_tests=)
  test "test given case 1" do
    # testing the post part
    post receipts_process_path,
      params: {
        "retailer": "Target",
        "purchaseDate": "2022-01-01",
        "purchaseTime": "13:01",
        "items": [
          {
            "shortDescription": "Mountain Dew 12PK",
            "price": "6.49"
          },{
            "shortDescription": "Emils Cheese Pizza",
            "price": "12.25"
          },{
            "shortDescription": "Knorr Creamy Chicken",
            "price": "1.26"
          },{
            "shortDescription": "Doritos Nacho Cheese",
            "price": "3.35"
          },{
            "shortDescription": "   Klarbrunn 12-PK 12 FL OZ  ",
            "price": "12.00"
          }
        ],
        "total": "35.35"
      }.to_json,
      headers: {"Content-Type" =>"application/json"}
    
    assert response.status == 200, "Post request was not succesfull."
    assert response.content_type.include?("application/json"), "Post response is not a JSON object."

    post_response = response.parsed_body
    assert post_response.has_key?(:id)
    assert !post_response[:id].nil?, "Null id returned."

    # testing the get part
    get "/receipts/#{post_response[:id]}/points"

    assert response.status == 200, "Get request was not succesfull."
    assert response.content_type.include?("application/json"), "Get response is not a JSON object."

    get_response = response.parsed_body
    assert get_response.has_key?(:points)
    assert !get_response[:points].nil?, "Null points returned."    
    assert get_response[:points] == 28, "Points total does not match expected value. Points returned #{get_response[:points]} != 28"
  end

  test "test given case 2" do
    # testing the post part
    post receipts_process_path,
      params: {
        "retailer": "M&M Corner Market",
        "purchaseDate": "2022-03-20",
        "purchaseTime": "14:33",
        "items": [
          {
            "shortDescription": "Gatorade",
            "price": "2.25"
          },{
            "shortDescription": "Gatorade",
            "price": "2.25"
          },{
            "shortDescription": "Gatorade",
            "price": "2.25"
          },{
            "shortDescription": "Gatorade",
            "price": "2.25"
          }
        ],
        "total": "9.00"
      }.to_json,
      headers: {"Content-Type" =>"application/json"}
    
    assert response.status == 200, "Post request was not succesfull."
    assert response.content_type.include?("application/json"), "Post response is not a JSON object."

    post_response = response.parsed_body
    assert post_response.has_key?(:id)
    assert !post_response[:id].nil?, "Null id returned."

    # testing the get part
    get "/receipts/#{post_response[:id]}/points"

    assert response.status == 200, "Get request was not succesfull."
    assert response.content_type.include?("application/json"), "Get response is not a JSON object."

    get_response = response.parsed_body
    assert get_response.has_key?(:points)
    assert !get_response[:points].nil?, "Null points returned."
    assert get_response[:points] == 109, "Points total does not match expected value. Points returned #{get_response[:points]} != 109"
  end
end
