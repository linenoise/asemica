  function run(){
      var fmt
      if (document.getElementById('poem').checked === true) {
        fmt = 'poem'
      } else if (document.getElementById('email').checked === true) {
        fmt = 'email'
      } else {
        fmt = 'none'
      }
      var op
      if (document.getElementById('d').value === "ON") {
        op = 'enc'
      } else {
        op = 'dec'
      }
      var val = {
        operation: op,
        format: fmt,
        txt: document.getElementById('words').value,
      }
      var data = JSON.stringify(val)
    }
