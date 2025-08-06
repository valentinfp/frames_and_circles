module V1
  class FramesController < ApplicationController
    before_action :set_frame, only: [ :show, :destroy ]

    # GET /v1/frames/:id
    def show
      render json: @frame
    end

    # POST /v1/frames
    def create
      frame = Frame.new(frame_params)
      if frame.save
        render json: frame, status: :created
      else
        render json: { errors: frame.errors.full_messages }, status: :unprocessable_content
      end
    end

    # DELETE /v1/frames/:id
    def destroy
      frame = Frame.find(params[:id])
      if frame.destroy
        head :no_content
      else
        render json: { errors: frame.errors.full_messages }, status: :unprocessable_content
      end
    end

    private
    def set_frame
      @frame = Frame.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Frame not found" }, status: :not_found
    end

    def frame_params
      params.require(:frame).permit(:width, :height, :x, :y, circles_attributes: [ :diameter, :x, :y ])
    end
  end
end
