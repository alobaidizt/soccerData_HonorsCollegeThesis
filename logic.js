function detection_logic(eventData) {
    var interim_transcript = '';
    for (var i = eventData.resultIndex; i < eventData.results.length; ++i) {
      if (eventData.results[i].isFinal) {
        final_transcript += eventData.results[i][0].transcript;
      } else {
        end_timestamp = eventData.timeStamp;
        time_diff = new Date(end_timestamp) - new Date(start_timestamp);
        console.log("end");
        console.log(time_diff);
        console.log(eventData.results[i][0].transcript);

        //var numbers = /(\b\d+(?:[\.,]\d+)?\b(?!(?:[\.,]\d+)|(?:\s*(?:%|percent))))/g;

        //console.log(eventData.results[i][0].transcript.match(numbers));







        if ((eventData.results[i][0].transcript).indexOf('rebound') >= 0)
        {
          var min = Math.floor(time_diff / 60000);
          var sec = ((time_diff % 60000) / 1000).toFixed(0);
          url = "https://www.youtube.com/watch?v=f5iA3yq4KUk#t=" + min + 'm' + sec + 's';
          recognition.stop();
        }
        interim_transcript += eventData.results[i][0].transcript;
      }
    }
    final_transcript = capitalize(final_transcript);
    final_span.innerHTML = linebreak(final_transcript);
    interim_span.innerHTML = linebreak(interim_transcript);
    if (final_transcript || interim_transcript) {
      showButtons('inline-block');
    }
}
