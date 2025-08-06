require 'swagger_helper'

RSpec.describe 'v1/frames', type: :request do

  path '/frames' do
    post('Create frame') do
      tags %w[Frames]
      consumes 'application/json'
      produces 'application/json'
      parameter name: :frame, in: :body, schema: {
        type: :object,
        properties: {
          width: { type: :number, format: 'float', minimum: 0, exclusive_minimum: true, default: 800 },
          height: { type: :number, format: 'float', minimum: 0, exclusive_minimum: true, default: 600 },
          x: { type: :number, format: 'float', default: 0 },
          y: { type: :number, format: 'float', default: 0 },
          circles_attributes: {
            type: :array,
            items: {
              type: :object,
              properties: {
                diameter: { type: :number, format: 'float', minimum: 0, exclusive_minimum: true, default: 5 },
                x: { type: :number, format: 'float', default: 0 },
                y: { type: :number, format: 'float', default: 0 }
              },
              required: %w[diameter x y]
            }
          }
        },
        required: %w[width height x y]
      }
      response(201, 'created') do
        let(:frame) { { width: 100, height: 100, x: 1000, y: 1000, circles_attributes: [] } }
        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
      response(422, 'unprocessable entity') do
        let(:frame) { { width: -100, height: 100, x: 1000, y: 1000 } }
        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end
  end

  path '/frames/{id}' do
    parameter name: 'id', in: :path, type: :string, description: 'ID of the frame to modify'
    let(:frame) { create(:frame_with_circles) }
    let(:id) { frame[:id] }

    get('Show frame') do
      tags %w[Frames]
      produces 'application/json'

      response(200, 'successful') do
        schema type: :object,
                properties: {
                  id: { type: :integer},
                  width: { type: :number, format: 'float', minimum: 0, exclusive_minimum: true, default: 800 },
                  height: { type: :number, format: 'float', minimum: 0, exclusive_minimum: true, default: 600 },
                  x: { type: :number, format: 'float', default: 0 },
                  y: { type: :number, format: 'float', default: 0 },
                  highest_circle: { type: :object,
                    properties: {
                      x: { type: :number, format: 'float', default: 300 },
                      y: { type: :number, format: 'float', default: 200 }
                    }
                  },
                  lowest_circle: { type: :object,
                    properties: {
                      x: { type: :number, format: 'float', default: 100 },
                      y: { type: :number, format: 'float', default: -250 }
                    }
                  },
                  leftmost_circle: { type: :object,
                    properties: {
                      x: { type: :number, format: 'float', default: 100 },
                      y: { type: :number, format: 'float', default: -250 }
                    }
                  },
                  rightmost_circle: { type: :object,
                    properties: {
                      x: { type: :number, format: 'float', default: 350 },
                      y: { type: :number, format: 'float', default: 0 }
                    }
                  },
                  total_circles: { type: :integer, default: 3 }
                },
                required: %w[id width height x y highest_circle lowest_circle leftmost_circle rightmost_circle total_circles]
        run_test!
      end

      response(404, 'not found') do
        let(:id) { 'nonexistent' }
        run_test!
      end
    end

    delete('Delete frame') do
      tags %w[Frames]
      response(204, 'no content') do
        run_test!
      end
    end
  end
end
