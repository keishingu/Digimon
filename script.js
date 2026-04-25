(function() {
  var monsterState;

  monsterState = {
    hunger: 4,
    vitality: 4,
    stage: 'Digitama',
    mode: 'idle',
    lastAction: 'spawn',
    actionCount: 0
  };

  window.digimonApp = {
    getState: function() {
      return {
        stage: monsterState.stage,
        hunger: monsterState.hunger,
        vitality: monsterState.vitality,
        mode: monsterState.mode,
        lastAction: monsterState.lastAction,
        actionCount: monsterState.actionCount
      };
    },
    setState: function(nextState) {
      if (nextState.stage != null) {
        monsterState.stage = nextState.stage;
      }
      if (nextState.hunger != null) {
        monsterState.hunger = nextState.hunger;
      }
      if (nextState.vitality != null) {
        monsterState.vitality = nextState.vitality;
      }
      if (nextState.mode != null) {
        monsterState.mode = nextState.mode;
      }
      if (nextState.lastAction != null) {
        monsterState.lastAction = nextState.lastAction;
      }
      if (nextState.actionCount != null) {
        monsterState.actionCount = nextState.actionCount;
      }
      return monsterState;
    }
  };
}).call(this);
