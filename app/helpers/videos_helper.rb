module VideosHelper
  def batch_textare_placeholder
    sample = %w(ePxKbPPj97Y Q3EblPrqk7g BoLt1VZ7sXE CrqhR9fbmLQ Y_7HFXmAptk
                Yv5ovdvvWoM cF2e2aS9HN8).each_with_object('') do |id, str|
      str << "https://www.youtube.com/watch?v=#{id}\r\n"
    end

    sample.prepend("مثال:\n")
  end
end
