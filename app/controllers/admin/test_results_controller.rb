class Admin::TestResultsController < ApplicationController
  def index
    @test_results = TestResult.all
  end
end
