import Foundation
/*
 Есть автомобиль.
 
 У автомобиля есть свои поля и методы.
 Добавить ошибки в виде перечисления, например (автомобиль заблокирован, отсутствует топливо, сел аккумулятор, открыта дверь и т.д.)

 
 Нужно сделать ряд сценариев из повседневной жизни, например:
 
 1. Нужно поехать с магазин.
 - разблокировать машину
 - открыть дверь
 - закрыть дверь (уже сели)
 - включить зажигание
 - завести автомобиль
 - проехать определенное кол-во км
 - заглушить
 - заблокировать
 
 Иметь ввиду, что не все метода кидают ошибки (загрушить автомобиль можно всегда. В нормальных ситуациях!)
 
 Минимум один нормальный сценарий и два с ошибкой. Сценарии могут быть свои, это был просто пример.
 Пример ошибочного сценария:
 
 - разблокировать
 - открыть дверь
 - закрыть дверь
 - включить зажигание -> Ошибка. Сел аккумулятор
 
 Обработка ошибок должна быть через do-catch.
 Ошибки должны обрабатываться через разные ветки do-catch, а не switch внутри одного catch.
 
 Это задание должно быть залито на Github.com.
 Ссылку на него нужно кинуть в личку преподавателю.
 */


enum CarError: Error {
    
  case carBlocked
  case notEnoughFuel
  case satBattery
  case doorOpen
  case turnOnIgnition
  case startCar
  case headLightsNotOn
  case doorsNotOpen
  case ignitionIsOn
  case carIsNotBlocked
  case headLightsInOn
}
class Car {
    
    var stateOfDoors = false
    var stateOfIgnition = false
    var stateOfCar = false
    var stateOfBlocking = true
    var stateOfBattery = true
    var stateOfHeadLights = false
    var countOfFuelInKm: Int
    
    init(countOfFuelInKm: Int = 10) {
        
        self.countOfFuelInKm = countOfFuelInKm
    }
    
    func openDoors() throws {
        
        guard stateOfBlocking == false else {
            
            throw CarError.carBlocked
        }
        guard stateOfDoors == false else {
            
            throw CarError.doorOpen
        }
        print("Двери открыты!")
        
        stateOfDoors = true
    }
    
    func closeDoors() throws {
        
        guard stateOfDoors == true else {
            
            throw CarError.doorsNotOpen
        }
        stateOfDoors = false
        
        print("Двери закрыты!")
    }
    
    func turnOnIgnition()  throws {
        
        guard stateOfBattery == true else {
            
            throw CarError.satBattery
        }
        guard stateOfIgnition == false else {
            
            throw CarError.ignitionIsOn
        }
        stateOfIgnition = true
        
        print("Зажигание включено!")
    }
    
    func turnOffIgnition() {
        
        if stateOfHeadLights == true {
            
            stateOfBattery = false
        }
        stateOfIgnition = false
        
        print("Зажигание выключено!")
    }
    
    func startCar() throws {
        
        guard stateOfIgnition == true else {
            
            throw CarError.turnOnIgnition
        }
        stateOfCar = true
        
        print("Машина заведена!")
    }
    
    func unblockCar() throws {
        
        guard stateOfBlocking == true else {
            
            throw CarError.carIsNotBlocked
    }
        
        stateOfBlocking = false
        
        print("Машина разблокированна!")
    }
    func blockCar() throws {
        
        guard stateOfBlocking == false else {
            
            throw CarError.carBlocked
        }
        stateOfBlocking = true
        
        print("Машина заблокированна!")
    }
    func drive(countOfKm: Int) throws {
        
        guard stateOfCar == true else {
            
            throw CarError.startCar
        }
        guard countOfKm <= countOfFuelInKm else {
            
            throw CarError.notEnoughFuel
        }
        
        countOfFuelInKm -= countOfKm
        
        print("Проехано: \(countOfKm), бензина осталось на \(countOfFuelInKm) км.")
    }
    
    func turnOnHeadLights() throws {
        
        guard stateOfIgnition == true else {
            
            throw CarError.turnOnIgnition
        }
        guard stateOfHeadLights == false else {
            
            throw CarError.headLightsInOn
        }
        stateOfHeadLights = true
        
        print("Фары включены!")
    }
    func turnOffHeadLights() throws {
        
        guard stateOfHeadLights == true else {
            
            throw CarError.headLightsNotOn
        }
        stateOfHeadLights = false
    }
    
}
// Положительный сценарий
var car = Car()

do {
    try car.unblockCar()
    
} catch CarError.carIsNotBlocked {
    
    print("Машина не заблокирована!")
    
}



do {
    try car.openDoors()
    
} catch CarError.carBlocked {
    
    print("Перед открытием дверей, разблокируйте машину!")
    
} catch CarError.doorOpen {
    
    print("Двери и так открыты!")
}

do {
    try car.closeDoors()
    
} catch CarError.doorsNotOpen {
    
    print("Двери и так закрыты!")
}


do {
    try car.turnOnIgnition()
    
} catch CarError.satBattery {
    
    print("Батарея разряжена!")
    
} catch CarError.ignitionIsOn {
    
    print("Зажигание и так включено!")
}
do {
    try car.turnOnHeadLights()
    
} catch CarError.headLightsInOn {
    
    print("Фары и так включены!")
    
} catch CarError.turnOnIgnition {
    
    print("Включите зажигание!")
}

do {
    try car.startCar()
    
} catch CarError.turnOnIgnition {
    
    print("Сначало включите зажигание!")
}

do {
    try car.drive(countOfKm: 9)
    
} catch CarError.startCar {
    
    print("Машина не заведена!")
    
} catch CarError.notEnoughFuel {
    
    print("Недостаточно бензина!")
}

car.turnOffIgnition()



do {
    try car.blockCar()
    
} catch CarError.carBlocked {
    
    print("Машина и так заблокированна!")
}

// Отрицательный сценарий с использованием положительного(в положительном сценарии хозяин забыл выключить фары из-за чего сел аккумулятор)

print("---------------")
do {
    try car.unblockCar()
    
} catch CarError.carIsNotBlocked {
    
    print("Машина не заблокирована!")
    
}


do {
    try car.turnOnIgnition()
    
} catch CarError.satBattery {
    
    print("Батарея разряжена!")
    
} catch CarError.ignitionIsOn {
    
    print("Зажигание и так включено!")
}

do {
    try car.turnOnHeadLights()
    
} catch CarError.headLightsInOn {
    
    print("Фары и так включены!")
    
} catch CarError.turnOnIgnition {
    
    print("Включите зажигание!")
}

do {
    try car.startCar()
    
} catch CarError.turnOnIgnition {
    
    print("Сначало включите зажигание!")
}

do {
    try car.blockCar()
    
} catch CarError.carBlocked {
    
    print("Машина и так заблокированна!")
}
print("---------------")

//Отрицательный сценарий где нехватает бензина для поездки.

var car2 = Car()
do {
    try car2.unblockCar()
    
} catch CarError.carIsNotBlocked {
    
    print("Машина не заблокирована!")
    
}



do {
    try car2.openDoors()
    
} catch CarError.carBlocked {
    
    print("Перед открытием дверей, разблокируйте машину!")
    
} catch CarError.doorOpen {
    
    print("Двери и так открыты!")
}

do {
    try car2.closeDoors()
    
} catch CarError.doorsNotOpen {
    
    print("Двери и так закрыты!")
}


do {
    try car2.turnOnIgnition()
    
} catch CarError.satBattery {
    
    print("Батарея разряжена!")
    
} catch CarError.ignitionIsOn {
    
    print("Зажигание и так включено!")
}
do {
    try car2.turnOnHeadLights()
    
} catch CarError.headLightsInOn {
    
    print("Фары и так включены!")
    
} catch CarError.turnOnIgnition {
    
    print("Включите зажигание!")
}

do {
    try car2.startCar()
    
} catch CarError.turnOnIgnition {
    
    print("Сначало включите зажигание!")
}

do {
    try car2.drive(countOfKm: 100)
    
} catch CarError.startCar {
    
    print("Машина не заведена!")
    
} catch CarError.notEnoughFuel {
    
    print("Недостаточно бензина!")
}

