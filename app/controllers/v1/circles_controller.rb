module V1
  class CirclesController < ApplicationController
    before_action :set_frame, only: [:create]
    before_action :set_circle, only: [:update, :destroy]

    # GET /frames/:frame_id/circles
    def index
      if params[:frame_id]
        @frame = Frame.find(params[:frame_id])
        @circles = @frame.circles
      else
        @circles = Circle.all
      end

      # Filter circles based on center and radius if provided
      if params[:center_x] && params[:center_y] && params[:radius]
        @circles = @circles.within_bounds(params[:center_x].to_f, params[:center_y].to_f, params[:radius].to_f)
      end

      render json: @circles
    end

    # POST /frames/:frame_id/circles
    def create
      circle = @frame.circles.new(circle_params)
      if circle.save
        render json: circle, status: :created
      else
        render json: { errors: circle.errors.full_messages }, status: :unprocessable_content
      end
    end

    # DELETE /circles/:id
    def destroy
      if @circle.destroy
        head :no_content
      else
        render json: { errors: @circle.errors.full_messages }, status: :not_found
      end
    end

    # PUT /circles/:id
    def update
      if @circle.update(circle_params)
        render json: @circle
      else
        render json: { errors: @circle.errors.full_messages }, status: :unprocessable_content
      end
    end

    private

    def set_frame
      @frame = Frame.find(params[:frame_id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'Frame not found' }, status: :not_found
    end

    def set_circle
      circles = @frame&.circles || Circle
      @circle = circles.find(params[:id])
      @frame ||= @circle.frame if @circle
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'Circle not found' }, status: :not_found
    end

    def circle_params
      params.require(:circle).permit(:diameter, :x, :y).merge(frame: @frame)
    end
  end
end
