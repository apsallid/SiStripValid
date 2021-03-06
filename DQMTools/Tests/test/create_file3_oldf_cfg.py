import FWCore.ParameterSet.Config as cms
import DQMTools.Tests.checkBooking as booking
import DQMTools.Tests.createElements as c
import sys

process =cms.Process("TEST")

b = booking.BookingParams(sys.argv)
b.doCheck(testOnly=False)

process.load('Configuration.EventContent.EventContent_cff')
process.load('Configuration.StandardSequences.EndOfProcess_cff')

process.source = cms.Source("EmptySource", numberEventsInRun = cms.untracked.uint32(100),
                            firstLuminosityBlock = cms.untracked.uint32(1),
                            firstEvent = cms.untracked.uint32(1000),
                            firstRun = cms.untracked.uint32(2),
                            numberEventsInLuminosityBlock = cms.untracked.uint32(1))

elements = c.createElements()

process.filler = cms.EDAnalyzer("DummyBookFillDQMStore",
                                folder    = cms.untracked.string("TestFolder/"),
                                elements  = cms.untracked.VPSet(*elements),
                                fillRuns  = cms.untracked.bool(True),
                                fillLumis = cms.untracked.bool(True),
                                book_at_constructor = cms.untracked.bool(b.getBookLogic('CTOR')),
                                book_at_beginJob = cms.untracked.bool(b.getBookLogic('BJ')),
                                book_at_beginRun = cms.untracked.bool(b.getBookLogic('BR')))

process.out = cms.OutputModule("PoolOutputModule",
                               splitLevel = cms.untracked.int32(0),
                               outputCommands = process.DQMEventContent.outputCommands,
                               fileName = cms.untracked.string('dqm_file3_oldf.root'),
                               dataset = cms.untracked.PSet(
    filterName = cms.untracked.string(''),
    dataTier = cms.untracked.string('')
    )
)

process.p = cms.Path(process.filler)
process.o = cms.EndPath(process.endOfProcess+process.out)

process.maxEvents = cms.untracked.PSet(input = cms.untracked.int32(10))

process.add_(cms.Service("DQMStore"))
#process.add_(cms.Service("Tracer"))

