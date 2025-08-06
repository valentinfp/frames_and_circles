require 'swagger_helper'

RSpec.describe 'v1/circles', type: :request do
  path '/circles' do
    # You'll want to customize the parameter types...

    let!(:frame) { create(:frame) }
    let(:frame_id) { frame[:id] }

    get('List circles') do
      tags %w[Circles]
      produces 'application/json'
      parameter name: 'center_x', in: :query, type: :number, format: 'float', description: 'Center X coordinate for filtering circles within a radius'
      parameter name: 'center_y', in: :query, type: :number, format: 'float', description: 'Center Y coordinate for filtering circles within a radius'
      parameter name: 'radius', in: :query, type: :number, format: 'float', description: 'Radius for filtering circles within a certain distance from the center point'
      parameter name: 'frame_id', in: :query, type: :integer, description: 'Filter circles by frame ID'

      let(:center_x) { 200 }
      let(:center_y) { 200 }
      let(:radius) { 150 }

      response(200, 'successful') do
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

  path '/frames/{frame_id}/circles' do
    let!(:frame) { create(:frame) }
    let(:frame_id) { frame[:id] }
    parameter name: 'frame_id', in: :path, type: :integer, description: 'ID of the frame to which the circles belong'

    post('Create circle') do
      tags %w[Circles]
      consumes 'application/json'
      produces 'application/json'
      parameter name: :circle, in: :body, schema: {
        type: :object,
        properties: {
          diameter: { type: :number, format: 'float', minimum: 0, exclusive_minimum: true, default: 5 },
          x: { type: :number, format: 'float', default: 0 },
          y: { type: :number, format: 'float', default: 0 }
        },
        required: %w[diameter x y]
      }
      response(201, 'created') do
        let(:circle) { { diameter: 10, x: 100, y: 100 } }

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
        let(:circle) { { diameter: -10, x: 100, y: 100 } }

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

  path '/circles/{id}' do
    let(:existing_circle) { create(:circle) }
    let(:id) { existing_circle[:id] }
    parameter name: 'id', in: :path, type: :string, description: 'ID of the circle to retrieve or modify'

    put('Update circle') do
      tags %w[Circles]
      consumes 'application/json'
      produces 'application/json'
      parameter name: :circle, in: :body, schema: {
        type: :object,
        properties: {
          diameter: { type: :number, format: 'float', minimum: 0, exclusive_minimum: true, default: 5 },
          x: { type: :number, format: 'float', default: 0 },
          y: { type: :number, format: 'float', default: 0 }
        },
        required: %w[diameter x y]
      }
      response(200, 'successful') do
        let(:circle) { { diameter: 20, x: 150, y: 150 } }
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
        let(:circle) { { diameter: -20, x: 150, y: 150 } }
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
    delete('Delete circle') do
      tags %w[Circles]
      response(204, 'no content') do
        run_test!
      end
      response(404, 'not found') do
        let(:id) { 'nonexistent' }
        run_test!
      end
    end
  end
end
