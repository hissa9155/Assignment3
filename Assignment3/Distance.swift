class Distance:CustomStringConvertible, Equatable, Comparable {

  private static let INCHES_IN_FOOT = 12
  private static let FEET_IN_YARD = 3
  private static let YARDS_IN_MILE = 1760
  
  private var miles:Int
  private var yards:Int
  private var feet:Int
  private var inches:Int
  
  var description: String{
    var str = "("
    if miles != 0 {
      str.append("\(miles)m ")
    }
    if yards != 0 {
      str.append("\(yards)y ")
    }
    if feet != 0 {
      str.append("\(feet)' ")
    }
    str.append("\(inches)\")")
    
    return str
  }
  
  init?() {
    self.miles = 0
    self.yards = 0
    self.feet = 0
    self.inches = 0
  }
  
  init?(inches:Int) {
    if inches < 0 {
      return nil
    }
    
    let params = Distance.getSimplifiedParams(inches)
    self.miles = params.miles
    self.yards = params.yards
    self.feet = params.feet
    self.inches = params.inches
  }
  
  init?(miles:Int, yards:Int, feet:Int, inches:Int){
    if miles < 0 || yards < 0 || feet < 0 || inches < 0 {
      return nil
    }
    
    let params = Distance.getSimplifiedParams(miles, yards, feet, inches)
    self.miles = params.miles
    self.yards = params.yards
    self.feet = params.feet
    self.inches = params.inches
  }
  
  //---------------------------------------
  // Operator overloading
  //---------------------------------------
  static func +(lhs:Distance, rhs:Distance) -> Distance {
    let _inches = lhs.inches + rhs.inches
    let feetAndInches = getConvertedFeetAndInches(inches: _inches)
    
    let _feet = lhs.feet + rhs.feet + feetAndInches.feet
    let yardsAndFeet = getConvertedYardsAndFeet(feet: _feet)
    
    let _yards = lhs.yards + rhs.yards + yardsAndFeet.yards
    let milesAndYards = getConvertedMilesAndYards(yards: _yards)
    
    let _miles = lhs.miles + rhs.miles + milesAndYards.miles
    
    return Distance(miles:_miles, yards:milesAndYards.yards, feet:yardsAndFeet.feet, inches:feetAndInches.inches)!
  }
  
  static func -(lhs:Distance, rhs:Distance) -> Distance? {
    
    if lhs < rhs {
      return Distance()
    }
    
    let lhsInches = getInches(lhs.miles, lhs.yards, lhs.feet, lhs.inches)
    let rhsInches = getInches(rhs.miles, rhs.yards, rhs.feet, rhs.inches)
    
    let params = getSimplifiedParams(lhsInches - rhsInches)
    
    return Distance(miles:params.miles, yards:params.yards, feet:params.feet, inches:params.inches)
  }
  
  static func *(lhs:Distance, rhs:Int) -> Distance {
    if rhs <= 0 {
      return Distance()!
    }
    
    var _inches = getInches(lhs.miles, lhs.yards, lhs.feet, lhs.inches)
    _inches *= rhs
    
    let params = getSimplifiedParams(_inches)
    
    return Distance(miles:params.miles, yards:params.yards, feet:params.feet, inches:params.inches)!
  }
  
  static func +=(lhs: Distance, rhs: Int) {
    var _inches = getInches(lhs.miles, lhs.yards, lhs.feet, lhs.inches)
    _inches += rhs
    let params = getSimplifiedParams(_inches)
    lhs.miles = params.miles
    lhs.yards = params.yards
    lhs.feet = params.feet
    lhs.inches =  params.inches
  }
  
  static func -=(lhs: Distance, rhs: Int) {
    var _inches = getInches(lhs.miles, lhs.yards, lhs.feet, lhs.inches)
    _inches -= rhs
    
    if _inches < 0 {
      lhs.miles = 0
      lhs.yards = 0
      lhs.feet = 0
      lhs.inches = 0
    } else {
      let params = getSimplifiedParams(_inches)
      lhs.miles = params.miles
      lhs.yards = params.yards
      lhs.feet = params.feet
      lhs.inches =  params.inches
    }
  }
  
  //---------------------------------------
  // Equatable, Comparable
  //---------------------------------------
  static func < (lhs:Distance, rhs:Distance) -> Bool{
    if lhs.miles < rhs.miles {
      return true
    } else if lhs.miles > rhs.miles {
      return false
    }
    
    if lhs.yards < rhs.yards {
      return true
    } else if lhs.yards > rhs.yards {
      return false
    }
    
    if lhs.feet < rhs.feet {
      return true
    } else if lhs.feet > rhs.feet {
      return false
    }
    
    if lhs.inches < rhs.inches {
      return true
    } else {
      return false
    }
  }
  
  static func <= (lhs:Distance, rhs:Distance) -> Bool{
    if lhs.miles < rhs.miles {
      return true
    } else if lhs.miles > rhs.miles {
      return false
    }
    
    if lhs.yards < rhs.yards {
      return true
    } else if lhs.yards > rhs.yards {
      return false
    }
    
    if lhs.feet < rhs.feet {
      return true
    } else if lhs.feet > rhs.feet {
      return false
    }
    
    if lhs.inches < rhs.inches {
      return true
    } else if lhs.inches > rhs.inches {
      return false
    } else {
      return true
    }
  }
  
  static func > (lhs:Distance, rhs:Distance) -> Bool{
    if lhs.miles > rhs.miles {
      return true
    } else if lhs.miles < rhs.miles {
      return false
    }
    
    if lhs.yards > rhs.yards {
      return true
    } else if lhs.yards < rhs.yards {
      return false
    }
    
    if lhs.feet > rhs.feet {
      return true
    } else if lhs.feet < rhs.feet {
      return false
    }
    
    if lhs.inches > rhs.inches {
      return true
    } else {
      return false
    }
  }
  
  static func >= (lhs:Distance, rhs:Distance) -> Bool{
    if lhs.miles > rhs.miles {
      return true
    } else if lhs.miles < rhs.miles {
      return false
    }
    
    if lhs.yards > rhs.yards {
      return true
    } else if lhs.yards < rhs.yards {
      return false
    }
    
    if lhs.feet > rhs.feet {
      return true
    } else if lhs.feet < rhs.feet {
      return false
    }
    
    if lhs.inches > rhs.inches {
      return true
    } else if lhs.inches < rhs.inches {
      return false
    } else {
      return true
    }
  }
  
  static func == (lhs:Distance, rhs:Distance) -> Bool{
    return lhs.miles == rhs.miles && lhs.yards == rhs.yards && lhs.feet == rhs.feet && lhs.inches == rhs.inches
  }
  
  static func != (lhs:Distance, rhs:Distance) -> Bool{
    return !(lhs.miles == rhs.miles && lhs.yards == rhs.yards && lhs.feet == rhs.feet && lhs.inches == rhs.inches)
  }
  
  //---------------------------------------
  // Private methods
  //---------------------------------------
  private static func getSimplifiedParams(_ inches:Int) -> (miles:Int, yards:Int, feet:Int, inches:Int){
    let feetAndInches = Distance.getConvertedFeetAndInches(inches: inches)
    let yardsAndFeet = Distance.getConvertedYardsAndFeet(feet: feetAndInches.feet)
    let milesAndYards = Distance.getConvertedMilesAndYards(yards: yardsAndFeet.yards)
    
    return (milesAndYards.miles, milesAndYards.yards, yardsAndFeet.feet, feetAndInches.inches)
  }
  
  private static func getSimplifiedParams(_ miles:Int, _ yards:Int, _ feet:Int, _ inches:Int)
  -> (miles:Int, yards:Int, feet:Int, inches:Int){
    
    let feetAndInches = Distance.getConvertedFeetAndInches(inches: inches)
    let yardsAndFeet = Distance.getConvertedYardsAndFeet(feet: feet + feetAndInches.feet)
    let milesAndYards = Distance.getConvertedMilesAndYards(yards: yards + yardsAndFeet.yards)
    
    return (miles + milesAndYards.miles, milesAndYards.yards, yardsAndFeet.feet, feetAndInches.inches)
  }
  
  private static func getInches(_ miles:Int, _ yards:Int, _ feet:Int, _ inches:Int) -> Int {
    return ((miles * YARDS_IN_MILE + yards) * FEET_IN_YARD + feet) * INCHES_IN_FOOT + inches
  }
  
  
  private static func getConvertedFeetAndInches(inches:Int) -> (feet:Int, inches:Int){
    let _feet:Int = inches / INCHES_IN_FOOT
    let _inches:Int = inches % INCHES_IN_FOOT
    return (_feet, _inches)
  }
  
  private static func getConvertedYardsAndFeet(feet:Int) -> (yards:Int, feet:Int){
    let _yards:Int = feet / FEET_IN_YARD
    let _feet:Int = feet % FEET_IN_YARD
    return (_yards, _feet)
  }
  
  private static func getConvertedMilesAndYards(yards:Int) -> (miles:Int, yards:Int){
    let _miles:Int = yards / YARDS_IN_MILE
    let _yards:Int = yards % YARDS_IN_MILE
    return (_miles, _yards)
  }
}
