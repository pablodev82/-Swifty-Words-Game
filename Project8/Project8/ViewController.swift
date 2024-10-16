//
//  ViewController.swift
//  Project8
//
//  Created by Admin on 27/09/2024.
//

import UIKit

class ViewController: UIViewController {
    var cluesLabel: UILabel!    // etiqueta UI implicitamemnte desenvuelta !
    var answersLabel: UILabel!
    var currentAnswer: UITextField!
    var scoreLabel: UILabel!
    var letterButtons = [UIButton]()  // crea una vista WKWeb
    
    var activatedButtons = [UIButton]()  // botones activados son una serie de botones de interfaz de usuario / esto almacenara todos los botones que el usuario esta tocando
    var solutions = [String]()  // soluciones una matriz de cadenas
    
    var score = 0 {    // puntuacion inicia en 0
        didSet {
            scoreLabel.text = "Score: \(score)"  // cada ve que cambien las puntuaciones ,se actualizara en la parte superior de la pantalle
        }
    }
    
    var level = 1  // parte del nivel 1
    

    override func loadView() {
        view = UIView()       // ve aqui la clase principal de todos los kits de interfaz de usuario, etiquetas,botones,vista de progreso, etc.
        view.backgroundColor = .white    // color del la pantalla de fondo

        scoreLabel = UILabel()
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.textAlignment = .right
        scoreLabel.text = "Score 0"
        scoreLabel.font = UIFont.systemFont(ofSize: 30)
        view.addSubview(scoreLabel)
        
        cluesLabel = UILabel()    //   estas partes son las pistas (clues)
        cluesLabel.translatesAutoresizingMaskIntoConstraints = false
        cluesLabel.font = UIFont.systemFont(ofSize: 24)
        cluesLabel.text = "CLUES"
        cluesLabel.textAlignment = .center   // el texto se centra
        cluesLabel.numberOfLines = 0
        cluesLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)  // configuramos el diseño vertical
        view.addSubview(cluesLabel)
        
        answersLabel = UILabel()   // estas son las respuestas (answers)
        answersLabel.translatesAutoresizingMaskIntoConstraints = false
        answersLabel.font = UIFont.systemFont(ofSize: 24)
        answersLabel.text = "ANSWERS"
        answersLabel.textAlignment = .center
        answersLabel.numberOfLines = 0
        answersLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        view.addSubview(answersLabel)
        
        currentAnswer = UITextField()     // dira que la respuesta actual es un nuevo campo de texto de la interfaz de usuario
        currentAnswer.translatesAutoresizingMaskIntoConstraints = false  //
        currentAnswer.placeholder = "Tap letters to guess"  // el texto se nmuestra antes de que el ususrio escriba un enlace
        currentAnswer.textAlignment = .center   // se alineara el texto al centro
        currentAnswer.font = UIFont.systemFont(ofSize: 44)  // la fuente de la interfaz de usuario tiene un tamaño de 44
        currentAnswer.isUserInteractionEnabled = false
        view.addSubview(currentAnswer)  // ver la respuesta
        
        // no tenemos que almacenar estas cosas como propiedades en el controlador de vista porque no necesiatamos ajustarlas mas adelante
        // en estos 2 let decimos que se han enviado y borrado independientemente del estado del juego
        
        let submit = UIButton(type: .system)  // decimos que envio es igual a nuevo boton de UI
        submit.translatesAutoresizingMaskIntoConstraints = false
        submit.setTitle("SUBMIT", for: .normal)  // titulo el conjunto se enviara para el estado del control normal
        submit.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)  // boton de enviar toca el controlador de vista
        view.addSubview(submit)  // agregar vista secundaria y enviar
        
        let clear = UIButton(type: .system)  //  botones de borrar
        clear.translatesAutoresizingMaskIntoConstraints = false
        clear.setTitle("CLEAR", for: .normal)
        clear.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)  // llama a borrar cuando se activa el boton
        view.addSubview(clear)
        
        let buttonsView = UIView()  // codigo de creacion de vista anterior
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsView)  // agregar vista de botones
        
        // la etiqueta de pistas se fijara en el borde anterior de la pantallacon una sangria de 100 puntos para que se vea mas ordenada
        // matriz de restricciones ⬇️
        NSLayoutConstraint.activate([   // este es el diseño de guia de margenes
            scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),  // parte superior del diseño
            scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            cluesLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            cluesLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 100),
            cluesLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.6, constant: -100 ),
            
            answersLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            answersLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -100),
            answersLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.4, constant:  -100),
            answersLabel.heightAnchor.constraint(equalTo: cluesLabel.heightAnchor),
            
            currentAnswer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentAnswer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            currentAnswer.topAnchor.constraint(equalTo: cluesLabel.bottomAnchor, constant: 20), // colocamos las letras debajo de las barras
            
            submit.topAnchor.constraint(equalTo: currentAnswer.bottomAnchor),  // restricccion del anclaje superior igual a la respuesta actual
            submit.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100),  // restricccon del punto de anclaje centro X left 100 puntos
            submit.heightAnchor.constraint(equalToConstant: 44),  // punto de anclaje de altura igual a la constante 44 puntos
            clear.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100), // hacemos el boton borrar,ancla 100 positivo se mueve ala derecha
            clear.centerYAnchor.constraint(equalTo: submit.centerYAnchor),
            clear.heightAnchor.constraint(equalToConstant: 44),  // todos estos son 2 nuevos botones en la panalla centrados horizontalmente
            
            buttonsView.widthAnchor.constraint(equalToConstant: 750),  // esta parte le damos los margenes a los botones
            buttonsView.heightAnchor.constraint(equalToConstant: 320),
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsView.topAnchor.constraint(equalTo: submit.bottomAnchor, constant: 20),
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20),
            
            
            
        ])
        
        let width = 150   // le damos el ancho y alto a cada boton
        let height = 80
        
          // creamos un bucle con 20 botones como una cuadricula de 4 x 5
        
        for row in 0..<4 {  // diremos para la fila en 0 hasta excluir 4
            for column in 0..<5 {  // para la columna en 0 hasta un saludo 5
                let letterButton = UIButton(type: .system)  // l damos un tema de fuente grande y agradable
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 36)  // boton de letra.titulo de etiqueta es igual a una fuente del sistema size = 36
                letterButton.setTitle("WWW", for: .normal)
                letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
                
                
                let frame = CGRect(x: column * width, y: row * height, width: width, height: height)
                letterButton.frame = frame
                
                buttonsView.addSubview(letterButton)  // boton de vista secundario de anuncios y agregarlo a nuestra matriz de botones
                letterButtons.append(letterButton)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadLevel()  // llamamos al nivel de carga si no esto no funcionara
        
    }
    
    @objc func letterTapped(_ sender: UIButton) {  // aqui llamamos a los botones cuando se tocan con 3 funciones con objective-c
        guard let buttonTitle = sender.titleLabel?.text else { return }
        
        currentAnswer.text = currentAnswer.text?.appending(buttonTitle)  // agregue el titulo del boton a nuetro texto externo actual
        activatedButtons.append(sender)  // decimos: botones activados agrege al remitente
        sender.isHidden = true  // lo marcamos como oculto para que no puedan volver a tocarlo
        
    }
    
    @objc func submitTapped(_ sender: UIButton) {  // func boton enviar remitente
         guard let answerText = currentAnswer.text else { return }   // guardar si texto de respuesta es igual al punto de respuuesta atual
        
        if let solutionPosition = solutions.firstIndex(of:  answerText) {  // si la posicion de la solucion sea igual al primer indice de los puntos de las soluciones
            activatedButtons.removeAll()  // lea y elimine todos los botones de nuestra matriz de botones activados
            
            var splitAnswers = answersLabel.text?.components(separatedBy: "\n")  // respuestas divididas seran iguales a 2 etiquetas de respuestas de texto opcionales separadas
                                                                                 // por un salto de linea
            splitAnswers?[solutionPosition] = answerText  // la position de solucion entre corchetes es igual a que no hay texto
            answersLabel.text = splitAnswers?.joined(separator: "\n")  // etiqueta de texto es igual a respuestas divididas unido con un separador de salto e linea
            
            currentAnswer.text = ""
            score += 1  // cargamos agregamos 1 para para subir al siguiente nivel
            
            if score % 7 == 0 {
                let ac = UIAlertController(title: "Well done", message: "Are you ready for he next level", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title:  "Let's go", style: .default, handler: levelUp))  // llamar al nivel de carga para que se carguen y muestren nuevos archivos
                present(ac, animated:  true)
            } else {
                let ac = UIAlertController(title: "Correct", message: "Your guess is correct", preferredStyle:  .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                present(ac, animated: true)
                
                currentAnswer.text = ""
                
                for button in activatedButtons {
                    button.isHidden = false
                }
                
                activatedButtons.removeAll()
            }
        }
    }
    
    func levelUp(action: UIAlertAction) {
         level += 1
        
        solutions.removeAll(keepingCapacity: true)
        loadLevel()
        
        for button in letterButtons {  // recorremos todos nuestros botones con letras
            button.isHidden = false
        }
    }
    
    @objc func clearTapped(_ sender: UIButton) {  // func boton borrar remitente
        currentAnswer.text = ""   // texto del punto de respuesta es una cadena vacia
        
        for button in activatedButtons {  // boton en nuestra matriz de botones activados, el punto del boton es oculto
            button.isHidden = false
        }
        
        activatedButtons.removeAll()  // botones activados se eliminan o se deshacen
    }
    
    func loadLevel() {
        var clueString = ""  // esto contendra la cadena completa que se mostro en la etiqueta de pistas y la pista hexadecimal en si
        var solutionsString = ""  // cadena de soluciones
        var letterBits = [String]()  // bits de cadenas que contiene todas las letras posibles en nuestro nivel
        
        if let levelfileURL = Bundle.main.url(forResource: "level\(level)", withExtension: "txt") {  // cargamos nuestro archivo txt de nivel usando interpolacion de cadenas
            if let levelContents = try? String(contentsOf: levelfileURL) {  // es igual al ocntent de la cadena archivo de nivel
                var lines = levelContents.components(separatedBy: "\n")  // barra invertida significa un salto de linea en swift
                lines .shuffle()
                
                for (index, line) in lines.enumerated() {  // le damos un orden a las letras
                    let parts = line.components(separatedBy: ": ")
                    let answer = parts[0]
                    let clue = parts[1]
                    
                    clueString += "\(index + 1). \(clue)\n"  // agregamos una cadena de pistas
                    
                    let solutionWord = answer.replacingOccurrences(of: "|", with: "")  //  ponemos todo el codigo para las soluciones
                    
                    solutionsString += "\(solutionWord.count) letters\n"  // hacemos el conteo de soluciones y un salto de linea
                    solutions.append(solutionWord)  // matriz de soluciones para saber que palabra buscar
                    
                    let bits = answer.components(separatedBy: "|")
                    letterBits += bits  // se agrega todos esos bits a la coleccion completa de nuestro bits de letras
                    
                    letterButtons.shuffle()  // botons de letras se mesclan
                    
                    if letterButtons.count == letterBits.count {
                        for i in 0..<letterButtons.count {  // va a contar a travs de todos los botones, que van del 0 al 19, luego asigne el titulo de esos botones
                            letterButtons[i].setTitle(letterBits[i], for: .normal)  // para que sea el bit coincidente en nuestra matriz bits de letras
                        }
                    }
                }
            }
        }
        
        cluesLabel.text = clueString.trimmingCharacters(in: .whitespacesAndNewlines)   // estas 2 linesa le dan los espacios en blanco y lineas nuevas
        answersLabel.text = solutionsString.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

// esto funcionara muy bien en un Ipad pro, mini de cualquier tamaño / es cieto que construir una interfaz de usuario en un guion grafico habria sido mas facil,
// pero aprender a codificar la interfaz de usuario es una habilidad realmente importante
