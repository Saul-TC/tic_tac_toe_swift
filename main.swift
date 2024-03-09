// Importaciones
import Foundation

// Declaracion de variables globales
// Menus de opciones
let menus = [
             "main":[["-- Tic Tac Toe --", "null"], ["play", "scoreboard", "exit"]],
             "play":[["-- Play --", "main"], ["one_player", "two_players", "back"]],
             "one_player":[["-- One Player --", "play"], ["easy", "normal", "hard", "imposible", "back"]]
]
// Scoreboar - Tabla de puntuaciones
var scoreboard = [String:Int]()
scoreboard["Saul"] = 3000
// Menu en el que estamos dentro actualmente
var actualMenu = "main"
// Variable bandera
var flag = true
// Matriz del tablero
var board = [["O", "O", " "], [" ", " ", " "], [" ", " ", " "]]



// Funcion para leer teclas
func keyPressed() -> Character? {
  return readLine()!.first
}


// Funcion para imprimir un menu de opciones
func printMenu (menuData: [[String]], selectedOption: Int) {
  // Imprimir titulo
  print (menuData[0][0].replacingOccurrences(of: "_", with: " ").capitalized, terminator: "\n\n")
  // Imprimi las opciones del menu
  for (index, option) in menuData[1].enumerated() {
    // Modificar el texto para una mejor visualizacion
    let textEdited = option.replacingOccurrences(of: "_", with: " ").capitalized
    // Si la opcion esta seleccionada, imprimir '>'
    if selectedOption == index {
      print(" > \(textEdited)")
    } else {
      print("   \(textEdited)")
    }
  }
}


// Funcion principal
func main () {
  // Opcion seleccionada
  var selectedOption = 0
  // Bucle principal
  while (flag) {
    // Limpiar la consola
    print("\u{001B}[2J")
    // Imprimir el menu principal
    printMenu(menuData: menus[actualMenu]!, selectedOption: selectedOption)
    // Leer tecla
    let key = keyPressed()
    // Manejar la tecla presionada
    if (key == "s" && selectedOption < menus[actualMenu]![1].count-1) {
      selectedOption += 1
    } else if (key == "w" && selectedOption > 0) {
      selectedOption -= 1
    } else if (key == " ") {
      let option = menus[actualMenu]![1][selectedOption]
      if menus[option] is [[String]] {
        // Si se trata de un menu, cambiar a ese menu
        actualMenu = menus[actualMenu]![1][selectedOption]
      } else {
        // Si no se trata de un menu, actuamos en consecuencia
        switch (option) {
          case "exit":
            flag = false
            print ("Come back soon!")
          case "back":
            actualMenu = menus[actualMenu]![0][1]
            selectedOption = 0
          case "scoreboard":
            printScoreboard()
          case "two_players":
            twoPlayers()
          case "easy", "normal", "hard", "imposible":
            onePlayer(difficulty: option)
          default:
            print("Unexpected error: Was entry in default case in main loop switch")
        }
      }
    } else if (key == "q") {
      if (actualMenu == "main") {
        flag = false
        print ("Come back soon!")
      } else {
        actualMenu = menus[actualMenu]![0][1]
      }
    }
  }
}


// Funcion para mostrar taabla de puntuaciones
func printScoreboard () {
  // Limpiar consola
  print("\u{001B}[2J")
  // Imprimir datos
  for (name, score) in scoreboard {
    print("\(name) - \(score)")
  }
  print ("\nPress enter to continue...", terminator: "")
  readLine()!
}

// Funcion que ejecuta y maneja una partida de dos jugadores
func twoPlayers () {
  var gameOver = false
  var playerTurn = 0
  var endMessage = ""
  var xPoss = 0
  var yPoss = 0
  // Reiniciar el tablero
  resetBoard()
  while (!gameOver) {
    // Limpiar consola
    print ("\u{001B}[2J")
    print ("-- Two Players --\n")
    print ("Player 1: X Player 2: O\n\n")
    if (playerTurn == 0) {
      print ("Player 1's turn (X)\n")
    } else {
      print ("Player 2's turn (O)\n")
    }
    printBoard(xPoss: xPoss, yPoss: yPoss)
    switch (keyPressed()) {
      case " ":
        if (board[yPoss][xPoss] == " "){
          if (playerTurn == 0) {
            playerTurn = 1
            board[yPoss][xPoss] = "X"
          } else {
            playerTurn = 0
            board[yPoss][xPoss] = "O"
          }
        }
      case "w":
        if (yPoss > 0) {
          yPoss -= 1
        }
      case "s":
        if (yPoss < 2) {
          yPoss += 1
        }
      case "a": 
        if (xPoss > 0) {
          xPoss -= 1
        }
      case "d":
        if (xPoss < 2) {
          xPoss += 1
        }
      case "q": 
        gameOver = true
        if (playerTurn == 0) {
          print ("\nMatch stoped by Player 1(X) !!")
        } else {
          print ("\nMatch stoped by Plater 2(O) !!")
        }
        print ("\n\nPress enter to continue...", terminator: "")
        readLine()!
      default:
        print ("Unexpected error: Was entry in default case in twoPlayers switch")
    }
    switch (evaluateBoard(board:board)) {
      case "X":
        gameOver = true
        endMessage = "Player 1 (X) wins!!"
      case "O":
        gameOver = true
        endMessage = "Player 2 (O) wins!!"
      case "draw":
        gameOver = true
        endMessage = "It's a draw!!"
      case "indefined":
        continue
      default:
        print ("Unexpected error: Was entry in default case in twoPlayers switch")
    }
  }
  // Hacer una ultima impresion
  print ("\u{001B}[2J")
  print ("-- Two Players --\n")
  print ("Player 1: X Player 2: O\n\n")
  printBoard(xPoss: xPoss, yPoss: yPoss)
  print ("\n\n")
  print (endMessage)
  print ("\n\nPress enter to continue...", terminator: "")
  readLine()!
}

// Funcion que ejecuta y maneja una partida de un jugador
func onePlayer (difficulty: String) {
  // Variables necesarias
  var flag = true
  var gameOver = false
  var score = 0
  var matches = 0
  var victorys = 0
  var defeats = 0
  var draws = 0
  var xPoss = 0
  var yPoss = 0
  var endMessage = ""
  // Reiniciar el tablero
  while (flag) {
    resetBoard()
    // Si la IA esta en imposible tira primero
    if (difficulty == "imposible") {
      ai(difficulty: difficulty)
    }
    matches += 1
    while (!gameOver) {
      // Limpiar consola
      print ("\u{001B}[2J")
      print ("-- One Player --\n")
      print ("Matches: \(matches)")
      print ("Victorys: \(victorys), Defeats: \(defeats), Draws: \(draws)")
      print ("Player: (X), Score: \(score)\n")
      print ("AI: (O), difficulty: \(difficulty)\n\n")
      printBoard(xPoss: xPoss, yPoss: yPoss)
      // Manejar teclas presionadas
      switch (keyPressed()) {
        case " ":
          if (board[yPoss][xPoss] == " ") {
            board[yPoss][xPoss] = "X"
            if evaluateBoard(board:board) == "indefined" {
              ai(difficulty:difficulty)
            }
          }
        case "w":
          if (yPoss > 0) {
            yPoss -= 1
          }
        case "s":
          if (yPoss < 2) {
            yPoss += 1
          }
        case "a": 
          if (xPoss > 0) {
            xPoss -= 1
          }
        case "d":
          if (xPoss < 2) {
            xPoss += 1
          }
        case "q": 
          gameOver = true
          endMessage = "Match stoped by Player"
        default:
          print ("Unexpected error: Was entry in default case in twoPlayers switch")
      }
      // Evaluar el estado de la partida
      switch (evaluateBoard(board:board)) {
        case "X":
          victorys += 1
          gameOver = true
          endMessage = "Player wins!!"
        case "O":
          defeats += 1
          gameOver = true
          endMessage = "AI wins!!"
        case "draw":
          draws += 1
          gameOver = true
          endMessage = "It's a draw!!"
        case "indefined":
          continue
        default:
          print ("Unexpected error: Was entry in default case in onePlayer switch")
      }
    }
    // Sumar puntuacion
    switch (difficulty, evaluateBoard(board:board)) {
      case ("easy", "X"):
        score += 100*1
      case ("normal", "X"):
        score += 100*2
      case ("normal", "draw"):
        score += 100
      case ("hard", "X"):
        score += 100*3
      case ("hard", "draw"):
        score += 150
      case ("imposible", "X"):
        score *= 99999999999
      case ("imposible", "draw"):
        score += 200
      default:
        print("no points")
        break
    }
    // Hacer una ultima impresion del tablero para actualizar los datos
    print ("\u{001B}[2J")
    print ("-- One Player --\n")
    print ("Matches: \(matches)")
    print ("Victorys: \(victorys), Defeats: \(defeats), Draws: \(draws)")
    print ("Player: (X), Score: \(score)\n")
    print ("IA: (O), difficulty: \(difficulty)\n\n")
    printBoard(xPoss: xPoss, yPoss: yPoss)
    print ("\n\n\(endMessage)")
    // Preguntar si se quiere jugar de nuevo
    print ("\n\nDo you want to play again? (y/n)", terminator: "")
    if (keyPressed() == "n") {
      flag = false
    } else {
      gameOver = false
    }
  }
  // Guardar puntuacion
  print ("\n\nEnter your name: ", terminator: "")
  let name = readLine()!
  print ("\(name) you got \(score) points")
  scoreboard[name] = score
}

// IA
func ai(difficulty: String) {
  // Funcion interna para tirar aleatoreamente
  func randomChoice () -> Bool {
    while (true) {
      let x = Int.random(in: 0...2)
      let y = Int.random(in: 0...2)
      if (board[y][x] == " ") {
        board[y][x] = "O"
        return true
      }
    }
  }
  // Funcion interna para hacer una tirada ganadora
  func winningChoice () -> Bool {
    // Realizar todas las posibles jugadas y ve si alguna de ellas gana
    var copyBoard = board
    for (y, row) in copyBoard.enumerated() {
      for (x, value) in row.enumerated() {
        if (value == " ") {
          copyBoard[y][x] = "O"
          if (evaluateBoard(board:copyBoard) == "O") {
            board[y][x] = "O"
            return true
          } else {
            copyBoard[y][x] = " "
          }
        }
      }
    }
    return false
  }

  // Funcion interna para hacer una tirada que evite la victoria
  func defendChoice () -> Bool {
    /*
      Realizar todas las posibles jugadas de X y ve si alguna de ellas gana,
      si encuentra una, hacer una tirada que evite la victoria
    */
    var copyBoard = board
    for (y, row) in copyBoard.enumerated() {
      for (x, value) in row.enumerated() {
        if (value == " ") {
          copyBoard[y][x] = "X"
          if (evaluateBoard(board:copyBoard) == "X") {
            board[y][x] = "O"
            return true
          } else {
            copyBoard[y][x] = " "
          }
        }
      }
    }
    return false
  }
  // Funcion interna que busca la mejor jugada
  func bestChoice (char: String) -> [[Int]] {
    /*
    Medimos las posibles jugadas y la probabilidad de que cada una de ellas
    Guardamos mejor jugada, con la probabilidad de que gane y la retornamos
    */
    var bestChoice: [Int] = []
    var probabilityOfBestChoice = 0
    for (y, row) in board.enumerated() {
      for (x, value) in row.enumerated() {
        var probability = 0
        if board[y][x] == " " {
          var copyBoard = board
          copyBoard[y][x] = char
          if (evaluateBoard(board:copyBoard) == char) {
            probability += 1
          }
          for (y2, row2) in copyBoard.enumerated() {
            for (x2, value2) in row2.enumerated() {
              if (value2 == " ") {
                var copyCopyBoard = copyBoard
                copyCopyBoard[y2][x2] = char
                if (evaluateBoard(board:copyCopyBoard) == char) {
                  probability += 1
                }
                for (y3, row3) in copyCopyBoard.enumerated() {
                  for (x3, value3) in row3.enumerated() {
                    if (value3 == " ") {
                      var copyCopyCopyBoard = copyCopyBoard
                      copyCopyCopyBoard[y3][x3] = char
                      if (evaluateBoard(board:copyCopyCopyBoard) == char) {
                        probability += 1
                      }
                    }
                  }
                }
              }
            }
          }
        }
        if (probability > probabilityOfBestChoice) {
          probabilityOfBestChoice = probability
          bestChoice = [y, x]
        }
      }
    }
    return [[probabilityOfBestChoice], bestChoice]
  }


  switch (difficulty) {
    /* 
    La IA en facil tira aleatoriamente, pero si encuentra una jugada
    ganadora, la hace
    */
    case "easy" :
      if (winningChoice()) {
        return
      } else {
        randomChoice()
      }
    /*
      La IA en normal tira aleatoriamente, pero si encuentra una jugada
      ganadora, la hace, o si encuentra una jugada que evita la victoria
    */
    case "normal" :
      if (winningChoice()) {
        return
      } else if (defendChoice()) {
        return
      } else {
        randomChoice()
      }
    /*
      La IA en dificil hace la mejor jugada (aunque a veces falla), pero si encuentra una jugada
      ganadora, la hace, si no, tira una jugada que evite la victoria
    */
    case "hard":
      if (winningChoice()) {
        return
      } else if (defendChoice()) {
        return
      } else {
        bestChoice(char: "O")
      }
    // La IA en imposible hace la mejor jugada siempre
    case "imposible":
      if (winningChoice()) {
        return
      } else if (defendChoice()) {
        return
      } else {
        let bestChoiceX = bestChoice(char: "X")
        let bestChoiceO = bestChoice(char: "O")
        if (bestChoiceX[0][0] > bestChoiceO[0][0]) {
          if bestChoiceX[1] != nil {
            board[bestChoiceX[1][0]][bestChoiceX[1][1]] = "O"
          } else {
            randomChoice()
          }
        } else {
          if bestChoiceO[1] != nil {
            board[bestChoiceO[1][0]][bestChoiceO[1][1]] = "O"
          } else {
            randomChoice()
          }
        }
      }
    case "test":
      let choice = bestChoice(char: "X")
      print(choice)
      board[choice[1][0]][choice[1][1]] = "X"
    default:
      print ("Unexpected error: Was entry in default case in ia switch")
  }
}

// Funcion para resetear el tablero
func resetBoard () {
  board = [[" ", " ", " "], [" ", " ", " "], [" ", " ", " "]]
}

// Funcion para evaluar el estado del tablero
func evaluateBoard (board: [[String]]) -> String {
  // Todas las posibles combinaciones ganadoras
  let winnigCombinations = [
    [["*", "*", "*"], [" ", " ", " "], [" ", " ", " "]],
    [[" ", " ", " "], ["*", "*", "*"], [" ", " ", " "]],
    [[" ", " ", " "], [" ", " ", " "], ["*", "*", "*"]],
    [["*", " ", " "], ["*", " ", " "], ["*", " ", " "]],
    [["*", " ", " "], ["*", " ", " "], ["*", " ", " "]],
    [[" ", "*", " "], [" ", "*", " "], [" ", "*", " "]],
    [[" ", " ", "*"], [" ", " ", "*"], [" ", " ", "*"]],
    [["*", " ", " "], [" ", "*", " "], [" ", " ", "*"]],
    [[" ", " ", "*"], [" ", "*", " "], ["*", " ", " "]]
  ]

  var cointidences = 0
  // Comprobar si hay un ganador
  //   Para 'X'
  for combination in winnigCombinations {
    cointidences = 0
    for (index, row) in combination.enumerated() {
      for (index2, value) in row.enumerated() {
        if (value == "*" && board[index][index2] == "X") {
          cointidences += 1
        }
      }
    }
    if (cointidences == 3) {
      return "X"
    }
  }

  //   Para 'O'
  for combination in winnigCombinations {
    cointidences = 0
    for (index, row) in combination.enumerated() {
      for (index2, value) in row.enumerated() {
        if (value == "*" && board[index][index2] == "O") {
          cointidences += 1
        }
      }
    }
    if (cointidences == 3) {
      return "O"
    }
  }

  // Empate
  for row in board {
    for column in row {
      if (column == " ") {
        /*
          Si no hay ganador pero se encuentra aunque esa 
          un espacio vacio, la partida aun esta indefinida
          */
        return "indefined"
      }
    }
  }

  /*
    Si no hay ganador y no hay espacios vacios
    es un empate
  */
  return "draw"
}

// Funcion para imprimir el tablero
func printBoard (xPoss: Int, yPoss:Int) {
  for (index, row) in board.enumerated() {
    for (index2, value) in row.enumerated() {
      if xPoss == index2 && yPoss == index {
        print(">\(value)<", terminator: "")
      } else {
        print(" \(value) ", terminator: "")
      }
      if index2 != 2 {
        print ("|", terminator: "")
      }
    }
    if index != 2 {
      print ("\n-----------")
    }
  }
  print ("\n")
}

// Llamada a la funcion principal
main()