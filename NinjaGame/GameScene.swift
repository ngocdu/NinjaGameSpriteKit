//
//  GameScene.swift
//  NinjaGame
//
//  Created by developer on 11/26/14.
//  Copyright (c) 2014 Nguyen Ngoc Du. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    var monsters: [SKSpriteNode] = [SKSpriteNode]()
    var numberDestroy: Int = Int()
    var scoreMax = 10
    override func didMoveToView(view: SKView) {
        /* thay đổi màu của màn hình thành màu trắng */
        backgroundColor = SKColor.whiteColor()
        self.numberDestroy = 0
        // thêm bóng ma vào màn hình , sau mỗi giây ta thêm vào một bóng ma
        runAction(SKAction.repeatActionForever(
            SKAction.sequence([
                SKAction.runBlock(addMonster),
                SKAction.waitForDuration(1.0)
                ])
            ))
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            checkTouch(location)
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(#min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    func checkTouch(position: CGPoint) {
        var monstersRemove: [SKSpriteNode] = [SKSpriteNode]()
        for monster in monsters {
            var mP: CGPoint = CGPoint(x: monster.position.x, y: monster.position.y)
//            println(mP.x )
            let xDist: CGFloat = (position.x - monster.position.x)
            let yDist: CGFloat = (position.y - monster.position.y)
            let distance: CGFloat = sqrt((xDist * xDist) + (yDist * yDist))
            println(monster.size.width)
            if (distance < monster.size.width) {
                monstersRemove.append(monster)
                addPraticle(position)
            }
        }
        
        for monster in monstersRemove {
          //  monsters.removeAtIndex(indexOfAccessibilityElement(monster))
            monster.removeFromParent()
            numberDestroy = numberDestroy + 1
            if (numberDestroy > scoreMax) {
                let reveal = SKTransition.flipHorizontalWithDuration(0.5)
                let gameOverScene = GameOverScene(size: self.size, won: true)
                self.view?.presentScene(gameOverScene, transition: reveal)
            }

        }
    }
    
    
    func addMonster() {
        // tạo một sprite tên là monster
        let monster = SKSpriteNode(imageNamed: "monster")
        monsters.append(monster)
        // giới hạn toạ độ Y của monster
        let actualY = random(min: monster.size.height, max: size.height - monster.size.height)
        
        // đặt toạ độ cho monster ở phía sau bên phải màn hình
        monster.position = CGPoint(x: size.width + monster.size.width/2, y: actualY)
        
        // thêm monster vào màn hình game
        addChild(monster)
        
        // thời gian di chuyển của monster
        let actualDuration = random(min: CGFloat(4.0), max: CGFloat(5.0))
        
        // hành động di chuyển từ phải qua trái
        let actionMove = SKAction.moveTo(CGPoint(x: -monster.size.width/2, y: actualY), duration: NSTimeInterval(actualDuration))
        // xoá monster sau khi nó di chuyển xong
        let actionMoveDone = SKAction.removeFromParent()
        // kiểm tra nếu monster di chuyển qua mép trái màn hình thì kết thúc game
        let loseAction = SKAction.runBlock() {
            let reveal = SKTransition.flipHorizontalWithDuration(0.5)
            let gameOverScene = GameOverScene(size: self.size, won: false)
            self.view?.presentScene(gameOverScene, transition: reveal)
        }
        monster.runAction(SKAction.sequence([actionMove, loseAction, actionMoveDone]))
    }
    
    func addPraticle(p:CGPoint)
    {
        
    }

}
