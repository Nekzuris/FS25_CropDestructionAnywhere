CropDestructionAnywhere = {}

function CropDestructionAnywhere:update(dt, allowFoliageDestruction)
    if g_server ~= nil or self.vehicle.currentUpdateDistance < WheelDestruction.MAX_UPDATE_DISTANCE then
        if allowFoliageDestruction then
            local hasContact = self.wheel.physics.contact ~= WheelContactType.NONE
            local doFruitDestruction = hasContact and not self.isCareWheel
            if doFruitDestruction then
                for _, destructionNode in ipairs(self.destructionNodes) do
                    local repr = self.wheel.repr
                    local width = 0.5 * destructionNode.width
                    local length = math.min(0.5, 0.5 * destructionNode.width)
                    local xShift, yShift, zShift = localToLocal(destructionNode.node, repr, 0, 0, 0)
                    local x0, _, z0 = localToWorld(repr, xShift + width, yShift, zShift - length)
                    local x1, _, z1 = localToWorld(repr, xShift - width, yShift, zShift - length)
                    local x2, _, z2 = localToWorld(repr, xShift + width, yShift, zShift + length)
                    self:destroyFruitArea(x0, z0, x1, z1, x2, z2)
                end
            end
        end
    end
end

WheelDestruction.update = Utils.appendedFunction(WheelDestruction.update, CropDestructionAnywhere.update)
